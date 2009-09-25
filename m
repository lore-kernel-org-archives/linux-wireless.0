Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:62805 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZIYO4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 10:56:48 -0400
Received: by bwz6 with SMTP id 6so2084419bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 07:56:51 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: 2.6.31-git wireless broken
Date: Fri, 25 Sep 2009 16:56:44 +0200
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils> <Pine.LNX.4.64.0909250838420.3783@sister.anvils> <200909251045.38894.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909251045.38894.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909251656.44475.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 September 2009 10:45:38 Holger Schurig wrote:
> > I wonder, have there been more yet more regdom reworks since 2.6.31?
> > Would this be the stage at which regdom problems manifest?  I'm not
> > running whatever-it-is daemon for setting regdom, usually just patch
> > static char *ieee80211_regdom = "EU";
> > into my kernels; but in the past have only needed that when the router
> > decides to use channel 13 or something - currently it's on channel 1.
> 
> I've install crda and it works great with 2.6.31, althought I had
> to override the EEPROM, which reports bugus data:
> 
> -       ath_regd_sanitize(reg);
> -
> -       printk(KERN_DEBUG "ath: EEPROM regdomain: 0x%0x\n", reg->current_rd);
> +       reg->current_rd = CTRY_GERMANY | COUNTRY_ERD_FLAG;
> 
FYI: the athinfo (from the madwifi-project) utility can be used to write a
a sane regdomain code into the EEPROM chip on most ath5k cards.
