Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f196.google.com ([209.85.216.196]:52342 "EHLO
	mail-qc0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaBYQo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 11:44:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAL6TERTJPPF0tMDeUQMqqPqdc4fo00K-GmpiTeWAu6tfH_H-xA@mail.gmail.com>
References: <CAL6TERTJPPF0tMDeUQMqqPqdc4fo00K-GmpiTeWAu6tfH_H-xA@mail.gmail.com>
Date: Tue, 25 Feb 2014 11:44:54 -0500
Message-ID: <CAL6TERTfnnHT6XuwZ3UhXoDyBdV+u8PknrGKTfymmanMZAkT3A@mail.gmail.com> (sfid-20140225_174504_691985_0FB57E9C)
Subject: Re: backports-3.13.2-1 ath9k defconfig fails
From: Joe Kodweis <kodweisdev@gmail.com>
To: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Running make with defconfig-ath9k produces .config that does not
actually build ATH9K. This is observed on 3.13.2-1 and also
development retrieved 2014-02-25.

The previous stable version 3.12.8-1 does actually build ATH9K.
Something happened between 3.12.8-1 and 3.13.2-1 that is preventing
ATH9K from being built properly.

See the difference in resulting .config files after running "make
defconfig-ath9k" in these two versions of stable releases:

grep ATH  backports-3.13.2-1/.config
CPTCFG_ATH_CARDS=m
# CPTCFG_ATH_DEBUG is not set
# CPTCFG_ATH6KL is not set

grep ATH backports-3.12.8-1/.config
CPTCFG_ATH_COMMON=m
CPTCFG_ATH_CARDS=m
# CPTCFG_ATH_DEBUG is not set
CPTCFG_ATH9K_HW=m
CPTCFG_ATH9K_COMMON=m
CPTCFG_ATH9K_BTCOEX_SUPPORT=y
CPTCFG_ATH9K=m
# CPTCFG_ATH9K_AHB is not set
# CPTCFG_ATH9K_LEGACY_RATE_CONTROL is not set
CPTCFG_ATH9K_HTC=m
# CPTCFG_ATH9K_HTC_DEBUGFS is not set
# CPTCFG_ATH6KL is not set
# CPTCFG_ATH10K is not set
