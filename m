Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.ugent.be ([157.193.71.182]:51468 "EHLO smtp1.ugent.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab3JOHgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 03:36:41 -0400
Received: from localhost (mcheck3.ugent.be [157.193.71.89])
	by smtp1.ugent.be (Postfix) with ESMTP id 69CE88428
	for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 09:28:29 +0200 (CEST)
Received: from smtp1.ugent.be ([IPv6:::ffff:157.193.71.182])
	by localhost (mcheck3.UGent.be [::ffff:157.193.43.11]) (amavisd-new, port 10024)
	with ESMTP id PZlQE2EF7aQA for <linux-wireless@vger.kernel.org>;
	Tue, 15 Oct 2013 09:28:25 +0200 (CEST)
Received: from mail2.intec.ugent.be (mail2.intec.ugent.be [157.193.214.245])
	by smtp1.ugent.be (Postfix) with ESMTP id 21A2C83F5
	for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 09:28:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail2.intec.ugent.be (Postfix) with ESMTP id D4CE520
	for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 09:28:24 +0200 (CEST)
Received: from mail2.intec.ugent.be ([127.0.0.1])
	by localhost (mail2.intec.ugent.be [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yqx2uJPgdirT for <linux-wireless@vger.kernel.org>;
	Tue, 15 Oct 2013 09:28:24 +0200 (CEST)
Received: from [157.193.135.212] (dhcp-zdpt-212.intec.ugent.be [157.193.135.212])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: fvdabeele)
	by mail2.intec.ugent.be (Postfix) with ESMTPSA id C59A91F
	for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 09:28:24 +0200 (CEST)
Message-ID: <525CEE98.3010300@intec.ugent.be> (sfid-20131015_093651_993761_CABDE8DE)
Date: Tue, 15 Oct 2013 09:28:24 +0200
From: Floris Van den Abeele <floris.vandenabeele@intec.ugent.be>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Lower throughput in Ad-hoc than in Infrastructure mode?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While running throughput experiments using iperf I noticed that UDP
throughput in ad-hoc mode was considerably lower than in Infrastructure
mode. The setups I'm comparing is a 802.11a ad-hoc network consisting of
two clients vs a 802.11a infrastructure network consisting of an access
point and a client (11a because the tests were run in the 5GHz band).

For ad-hoc mode I'm consistenly seeing a lower throughput than for
infrastructure mode: i.e. 22.4 Mbits/sec vs 28.2 Mbits/sec. Note that
while sniffing the medium radiotap headers report a PHY data rate of
54Mbit/s in both cases. There is no other traffic on the Wi-Fi channel
in question (44). Considering the medium access for both setups is
similair I would expect to find similair throughputs. Is this a known
issue with the linux wireless/mac80211/ath9k driver stack or is this
behaviour conform the 802.11 standard (based on my knowledge I would say
no to the latter)? My test specs are below.

For testing I'm using Sparklan WPEA-111N NIC's (AR9280). The nodes are
running OpenWrt attitude adjusment on r32482 (from 2012-06-21) with the
REGD patch enabled. I believe that this build of OpenWRT uses the
compat-wireless-2012-06-14.tar.bz2 drivers.

Kind regards,
Floris

-- 
Floris Van den Abeele
Department of Information Technology
Internet Based Communication Networks and Services (IBCN)
Ghent University - iMinds
Gaston Crommenlaan 8 (Bus 201), B-9050 Gent, Belgium
M: +32 (0)494 24 92 76
E: floris.vandenabeele@intec.UGent.be
W : www.ibcn.intec.UGent.be

