Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from thoth.sbs.de ([192.35.17.2]:18279 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab0CWRKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 13:10:42 -0400
Received: from mail3.siemens.de (localhost [127.0.0.1])
	by thoth.sbs.de (8.12.11.20060308/8.12.11) with ESMTP id o2NHAeH6010302
	for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 18:10:40 +0100
Received: from DEMCHP99ET3MSX.ww902.siemens.net ([139.25.131.243])
	by mail3.siemens.de (8.12.11.20060308/8.12.11) with ESMTP id o2NHAeEg031708
	for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 18:10:40 +0100
From: "Porsch, Marco" <marco.porsch@siemens.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 23 Mar 2010 18:06:03 +0100
Subject: Re: Mesh mode broken in compat-wireless?
Message-ID: <7F2FE3504A6CB54497542A539E401A7B9A0C4297@DEMCHP99E15MSX.ww902.siemens.net>
References: <7F2FE3504A6CB54497542A539E401A7B9A0C4294@DEMCHP99E15MSX.ww902.siemens.net>
In-Reply-To: <7F2FE3504A6CB54497542A539E401A7B9A0C4294@DEMCHP99E15MSX.ww902.siemens.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hello list,
> 
> since compat-wireless-2010-03-03 (and the previous) mesh mode does not work for me anymore.
> The problem is, that peering links do not establish between mesh points. The peering status changes between LISTEN, OPN_SNT and HOLDING, but does not reach ESTAB.
> Using patched wireshark I can see lots of malformed packets in response to peer link management frames.
> I upgraded all my nodes to the same version. But the problem is the same with just one node on the newer version.
> 
> I am using latest OpenWrt with ye olde compat-wireless-2010-03-03 (no new version included until now). Driver is ath9k, hardware is Netgear WNDR3700.
> 
> The mesh configuration should be fine, sine with compat-wireless-2010-02-02 everything was ok.
> 
> I could not try this with standard hardware, so at first it would be interesting, if this is a general problem or just OpenWrt specific.
> 
> 
> Regards
> 
> Marco


Realizing there is a debug output switch for peer link management, I enabled it and recorded following outputs:
(using two PHYs and mesh interfaces on each node)

[   41.900000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   42.000000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 5
[   42.060000] Mesh plink: starting establishment with xX:xx:xX:xX:xX:xX
[   42.100000] Mesh plink: starting establishment with xx:xx:xx:xx:xx:xx
[   42.160000] Mesh plink timer for xX:xx:xX:xX:xX:xX fired on state 1
[   42.160000] Mesh plink for xX:xx:xX:xX:xX:xX (retry, timeout): 0 100
[   42.200000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   42.200000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 0 100
[   42.350000] Mesh plink timer for xX:xx:xX:xX:xX:xX fired on state 1
[   42.350000] Mesh plink for xX:xx:xX:xX:xX:xX (retry, timeout): 1 193
[   42.390000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   42.390000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 1 197
[   42.630000] Mesh plink timer for xX:xx:xX:xX:xX:xX fired on state 1
[   42.630000] Mesh plink for xX:xx:xX:xX:xX:xX (retry, timeout): 2 282
[   42.720000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   42.720000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 2 338
[   43.090000] Mesh plink timer for xX:xx:xX:xX:xX:xX fired on state 1
[   43.120000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   43.190000] Mesh plink timer for xX:xx:xX:xX:xX:xX fired on state 5
[   43.220000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 5
[   44.150000] Mesh plink: starting establishment with xx:xx:xx:xx:xx:xx
[   44.250000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   44.250000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 0 100
[   44.380000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   44.380000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 1 136
[   44.550000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   44.550000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 2 172
[   44.800000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   44.900000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 5
[   45.130000] Mesh plink: starting establishment with xX:xx:xX:xX:xX:xX
[   45.170000] Mesh plink: starting establishment with xx:xx:xx:xx:xx:xx
[   45.230000] Mesh plink timer for xX:xx:xX:xX:xX:xX fired on state 1
[   45.230000] Mesh plink for xX:xx:xX:xX:xX:xX (retry, timeout): 0 100
[   45.270000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   45.270000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 0 100
[   45.370000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   45.370000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 1 107
[   45.380000] Mesh plink timer for xX:xx:xX:xX:xX:xX fired on state 1
[   45.380000] Mesh plink for xX:xx:xX:xX:xX:xX (retry, timeout): 1 151
[   45.480000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   45.480000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 2 111
[   45.590000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   45.670000] Mesh plink timer for xX:xx:xX:xX:xX:xX fired on state 1
[   45.670000] Mesh plink for xX:xx:xX:xX:xX:xX (retry, timeout): 2 298
[   45.690000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 5
[   46.060000] Mesh plink timer for xX:xx:xX:xX:xX:xX fired on state 1
[   46.160000] Mesh plink timer for xX:xx:xX:xX:xX:xX fired on state 5
[   46.190000] Mesh plink: starting establishment with xx:xx:xx:xx:xx:xx
[   46.290000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   46.290000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 0 100
[   46.460000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   46.460000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 1 178
[   46.730000] Mesh plink timer for xx:xx:xx:xx:xx:xx fired on state 1
[   46.730000] Mesh plink for xx:xx:xx:xx:xx:xx (retry, timeout): 2 270
