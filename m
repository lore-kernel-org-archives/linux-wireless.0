Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:9006 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZG2L01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 07:26:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id BB4EB148008
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 13:26:27 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DjXQNL1zGKUy for <linux-wireless@vger.kernel.org>;
	Wed, 29 Jul 2009 13:26:27 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F9F0B.dip0.t-ipconnect.de [217.95.159.11])
	by mx51.mymxserver.com (Postfix) with ESMTP id 668C8148006
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 13:26:26 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 424CA1E004F
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 13:26:00 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: BUG: ifdown doesn't notify cfg80211
Date: Wed, 29 Jul 2009 13:25:51 +0200
References: <200907291310.50121.hs4233@mail.mn-solutions.de>
In-Reply-To: <200907291310.50121.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907291325.51598.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 29 July 2009 13:10:50 Holger Schurig wrote:
> # iw dev eth1 connect -w MNHS key 0:11111
> eth1 (phy #0): connected to 00:13:19:80:da:30
> # ifconfig eth1 down
> # iw dev eth1 connect -w MNHS key 0:11111
> # ifconfig eth1 down

Oops, a copy'n'paste error. I didn't send those two lines twice 
at this point. The correct sequence I did:

# iw dev eth1 connect -w MNHS key 0:11111
eth1 (phy #0): connected to 00:13:19:80:da:30
# ifconfig eth1 down
# ifconfig eth1 up
# iw dev eth1 connect -w MNHS key 0:11111
command failed: Operation already in progress (-114)

-- 
http://www.holgerschurig.de
