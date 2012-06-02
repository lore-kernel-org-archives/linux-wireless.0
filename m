Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33065 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933601Ab2FBSPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 14:15:01 -0400
Received: by wibhm6 with SMTP id hm6so1385511wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jun 2012 11:14:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338659135.12823.3.camel@jlt3.sipsolutions.net>
References: <1338532779-4621-1-git-send-email-mohammed@qca.qualcomm.com>
 <1338533070.4884.4.camel@jlt3.sipsolutions.net> <4FC86AB4.9020602@qca.qualcomm.com>
 <1338534832.4884.7.camel@jlt3.sipsolutions.net> <4FCA30DE.4080805@qca.qualcomm.com>
 <1338659135.12823.3.camel@jlt3.sipsolutions.net>
From: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
Date: Sat, 2 Jun 2012 15:14:39 -0300
Message-ID: <CAHD-aq+wyT2Rm-uYaA34Wspm1+J79=eyCbpiD=T4ti3Bv-MP9g@mail.gmail.com> (sfid-20120602_201535_765815_95E30E50)
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix a WARNING in suspend/resume with IBSS
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	stable@vger.kernel.org, Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 2, 2012 at 2:45 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> The sets are mutually exclusive, and there are implied sets of each
> interface with a max number of 1. So for example, in iwlwifi we don't
> advertise IBSS in the combinations at all, because it's not compatible
> with anything. In your case, I think the same applies, since you said
>
>        if the first interface is ADHOC we cannot have any other
>        interface. we cannot add an ADHOC interface if there is already
>        an interface is present

I've been following the thread and still can't get this confusion out
of my head:
i'm currently using kernel 3.3.2 (openwrt trunk r31439), with Atheros
AR9285 and i can succesfully combine IBSS interface with AP or STA
modes...

# iw dev
phy#0
	Interface wlan0-1
		ifindex 11
		type AP
	Interface wlan0-2
		ifindex 10
		type IBSS
	Interface wlan0
		ifindex 9
		type AP

So, does this patch mean this functionality will be lost in future
versions of ath9k?
or maybe it is officially unsupported and openwrt has patches applied?
or, even worse, I completely misunderstood what you're talking about?
(in that case i'm sorry for the noise)

Thanks a lot,

Guido
