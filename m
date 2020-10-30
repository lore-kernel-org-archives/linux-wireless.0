Return-Path: <SRS0=NAPm=EF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A8DC00A89
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Oct 2020 22:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE76320719
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Oct 2020 22:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgJ3WSX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Oct 2020 18:18:23 -0400
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:57422 "EHLO
        17.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgJ3WSX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Oct 2020 18:18:23 -0400
X-Greylist: delayed 1182 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2020 18:18:22 EDT
Received: from player774.ha.ovh.net (unknown [10.108.54.209])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 7966A265C66
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2020 22:58:38 +0100 (CET)
Received: from webmining-systems.com (lfbn-idf1-1-284-37.w86-195.abo.wanadoo.fr [86.195.122.37])
        (Authenticated sender: info@webmining-systems.com)
        by player774.ha.ovh.net (Postfix) with ESMTPSA id D2FA117C4225E;
        Fri, 30 Oct 2020 21:58:34 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-101G0040a5641ed-589e-4abf-ba11-83173663bd7e,
                    279B89908ABC8F04D5766AA394EABDEDD82A3687) smtp.auth=info@webmining-systems.com
From:   Michal TOMA <michaltoma@sicoop.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: rtw_8821ce driver in kernel 5.9.1: wifi module inactive
Date:   Fri, 30 Oct 2020 22:52:24 +0100
Message-ID: <2464818.GXZx34Hohp@linux-9g0r.site>
Organization: SICOOP
User-Agent: KMail/4.10.5 (Linux/3.7.10-1.45-desktop; KDE/4.10.5; x86_64; ; )
In-Reply-To: <3c2baab8-bdcf-0679-b396-b42a05a0ef38@lwfinger.net>
References: <6173742.tiux6Xeah1@linux-9g0r.site> <3c2baab8-bdcf-0679-b396-b42a05a0ef38@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Ovh-Tracer-Id: 10128032615724890566
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedrleehgdduhedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkfhofggjfhgggfgtsehtufertddtiedvnecuhfhrohhmpefoihgthhgrlhcuvffqofetuceomhhitghhrghlthhomhgrsehsihgtohhophdrtghomheqnecuggftrfgrthhtvghrnhepgfdvjeeluddtfeefgedvgfevveeigefgfeffjefgffdthfeileduteffveejleefnecukfhppedtrddtrddtrddtpdekiedrudelhedruddvvddrfeejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeejgedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehmihgthhgrlhhtohhmrgesshhitghoohhprdgtohhmpdhrtghpthhtoheplhhinhhugidqfihirhgvlhgvshhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Friday, October 30, 2020 01:35:45 PM Larry Finger wrote:
> On 10/29/20 11:47 AM, Michal TOMA wrote:
> > ->rfkill list
> > 0: ideapad_wlan: Wireless LAN
> > 
> >          Soft blocked: no
> >          Hard blocked: no
> > 
> > 1: ideapad_bluetooth: Bluetooth
> > 
> >          Soft blocked: yes
> >          Hard blocked: no
> > 
> > 2: hci0: Bluetooth
> > 
> >          Soft blocked: yes
> >          Hard blocked: no
> > 
> > 3: phy0: Wireless LAN
> > 
> >          Soft blocked: no
> >          Hard blocked: no
> 
> Those bluetooth soft blocks may stop wifi. Can you clear them?
> 
> Larry

No change with soft blocks cleared:

rfkill unblock 1
rfkill unblock 2
rfkill list 
0: ideapad_wlan: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: ideapad_bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
2: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
3: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no

iwlist wlp7s0 scan
wlp7s0    No scan results


