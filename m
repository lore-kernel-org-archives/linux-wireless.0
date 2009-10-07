Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:50146 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZJGHwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 03:52:14 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 7C3D014800D
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2009 09:51:06 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ny1ukq-qtuLf for <linux-wireless@vger.kernel.org>;
	Wed,  7 Oct 2009 09:51:06 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F948E.dip0.t-ipconnect.de [217.95.148.142])
	by mx51.mymxserver.com (Postfix) with ESMTP id E0B2614800A
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2009 09:51:05 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id DC1381E0036
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2009 09:50:55 +0200 (CEST)
From: Holger Schurig <h.schurig@mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Question regarding netif_stop/wake queue and libertas
Date: Wed, 7 Oct 2009 09:50:52 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910070950.52196.h.schurig@mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

In the libertas driver, we did the following before scanning:

	netif_stop_queue(priv->dev);
	netif_carrier_off(priv->dev);
	if (priv->mesh_dev) {
		netif_stop_queue(priv->mesh_dev);
		netif_carrier_off(priv->mesh_dev);
	}

and then, after scanning, we started the queues and carrier
again *IF* connected:

	if (priv->connect_status == LBS_CONNECTED) {
		netif_carrier_on(priv->dev);
		if (!priv->tx_pending_len)
			netif_wake_queue(priv->dev);
	}
	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED)) {
		netif_carrier_on(priv->mesh_dev);
		if (!priv->tx_pending_len)
			netif_wake_queue(priv->mesh_dev);
	}

How should I do this in my CFG80211-based scanning? As I want
to move away from libertas' own association logic in assoc.c,
there will in future be no priv->connect_status.

I now plan to remember the running/carrier state of both the
"normal" and the "mesh" device:

	int running;
	int carrier;
	int mesh_running = false;
	int mesh_carrier = false;

	running = !netif_queue_stopped(priv->dev);
	carrier = netif_carrier_ok(priv->dev);
	if (running)
		netif_stop_queue(priv->dev);
	if (carrier)
		netif_carrier_off(priv->dev);
	if (priv->mesh_dev) {
		mesh_running = !netif_queue_stopped(priv->mesh_dev);
		mesh_carrier = netif_carrier_ok(priv->mesh_dev);
		if (mesh_running)
			netif_stop_queue(priv->mesh_dev);
		if (mesh_carrier)
			netif_carrier_off(priv->mesh_dev);
	}

And after scanning my four channels, I plan to turn them
on again (e.g. this can be 440 ms later when doing a passive
scan):

	if (carrier)
		netif_carrier_on(priv->dev);
	if (running && !priv->tx_pending_len)
		netif_wake_queue(priv->dev);
	if (mesh_carrier)
		netif_carrier_on(priv->mesh_dev);
	if (mesh_running %% !priv->tx_pending_len)
		netif_wake_queue(priv->mesh_dev)

Would I need some kind of locking ?

-- 
M&N Solutions GmbH          Ein Unternehmen der Datagroup AG
Holger Schurig
Raiffeisenstr. 10
61191 Rosbach
Tel: 06003/9141-15          Fax 06003/9141-49
http://www.mn-solutions.de/

Handelsregister Friedberg, HRB 5903
Geschäftsführer: P.Schrittenlocher
