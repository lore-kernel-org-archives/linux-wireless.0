Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53042 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161454AbaKNRSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 12:18:43 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so122792wiw.2
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2014 09:18:42 -0800 (PST)
Date: Fri, 14 Nov 2014 18:18:32 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v6] mac80211: minstrel_ht: add basic support for VHT
 rates <= 3SS@80MHz
Message-ID: <20141114171832.GA16541@magnum.frso.rivierawaves.com> (sfid-20141114_181853_037101_017279D0)
References: <1413812762-6605-5-git-send-email-karl.beldan@gmail.com>
 <1413880718-31273-1-git-send-email-karl.beldan@gmail.com>
 <20141114164328.GA30967@w1.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20141114164328.GA30967@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Nov 14, 2014 at 06:43:28PM +0200, Jouni Malinen wrote:
> On Tue, Oct 21, 2014 at 10:38:38AM +0200, Karl Beldan wrote:
> > When the new CONFIG_MAC80211_RC_MINSTREL_VHT is not set (default 'N'),
> > there is no behavioral change including in sampling and MCS_GROUP_RATES
> > remains 8.
> > Otherwise MCS_GROUP_RATES is 10, and a module parameter *vht_only*
> > (default 'true'), restricts the rates selection to VHT when vht is
> > supported.
> 
> Have you tested this with mac80211_hwsim? I'm seeing number of issues in

Yes, only with iw and nothing fancy, I also have had it running on some 
boards for some weeks as is and with rfc version for more than a year at
work (minstrel not the whole tree).
I guess I can take the tip of wireless-testing but can you give your
HEAD though ?

> hwsim test cases with CONFIG_MAC80211_RC_MINSTREL_VHT=y with
> wireless-testing.git. These disappear if I disable this build option.
> 
> For example, with nfc_p2p_go_neg test case:
> 

Have you reproduced it with other testcases (maybe more regular so that
I can get my hands on it faster) ?
Is it also happening when VHT support is not advertized by upper layers
?


Rgds,
 
Karl
