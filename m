Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.brikks.com ([82.209.166.4]:23972 "EHLO smtp.bredband2.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753177AbYLIPQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 10:16:58 -0500
Date: Tue, 9 Dec 2008 16:16:55 +0100
From: Mats Johannesson <spamcan1@abrasax.se>
To: Sujith <m.sujith@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni.Malinen@atheros.com
Subject: Re: [RFC v2] mac80211: Fix HT channel selection
Message-ID: <20081209161655.28b66802@loke.fish.not> (sfid-20081209_161701_305390_8CF072B8)
In-Reply-To: <18750.29471.106723.987402@localhost.localdomain>
References: <20081209135456.68778e51@loke.fish.not>
	<200812091314.34169.hs4233@mail.mn-solutions.de>
	<18750.29471.106723.987402@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Sujith, there seems to be a slight issue. After having done a scan (one
is enough) DNS lookups start to be delayed. Prior to a scan I get
maximum 1 seconds DNS lookups, after scan it can be like 5 seconds up
to 25 and even to the point of timeout.

I've tested this several times now, for some hours, and am rather
confident that the scan is the culprit. It is very obvious at marc.info
where the DNS in addition seems to be forgotten within minutes,
requiring a new lookup. Possibly the DNS is forgotten normally as well,
but the lookup is so quick that I don't notice it...

/Mats
