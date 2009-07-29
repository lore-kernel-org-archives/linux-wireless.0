Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:4420 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbZG2NAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 09:00:16 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id C5A2B14800D
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 15:00:15 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z5xjzeyBsTgk for <linux-wireless@vger.kernel.org>;
	Wed, 29 Jul 2009 15:00:15 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F9F0B.dip0.t-ipconnect.de [217.95.159.11])
	by mx51.mymxserver.com (Postfix) with ESMTP id 71112148006
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 15:00:14 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 2618F1E004F
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 15:00:05 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: BUG: ifdown doesn't notify cfg80211
Date: Wed, 29 Jul 2009 14:59:55 +0200
References: <200907291310.50121.hs4233@mail.mn-solutions.de> <200907291325.51598.hs4233@mail.mn-solutions.de>
In-Reply-To: <200907291325.51598.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907291459.55484.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> # iw dev eth1 connect -w MNHS key 0:11111
> eth1 (phy #0): connected to 00:13:19:80:da:30
> # ifconfig eth1 down
> # ifconfig eth1 up
> # iw dev eth1 connect -w MNHS key 0:11111
> command failed: Operation already in progress (-114)

As Johannes pointed out on IRC, this happens only if you used

iwconfig eth1 key s:11111
iwconfig eth1 essid MNHS

previously on the device. Seems that the CFG80211-configuration 
doesn't delete the WEXT-configuration remnants. And as soon as 
you "ifup" the device, it starts associating based on old WEXT 
data, resulting in the busy.

-- 
http://www.holgerschurig.de
