Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56459 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaJRJ3J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 05:29:09 -0400
Message-ID: <544232E1.3000005@openwrt.org> (sfid-20141018_112913_071422_3475ECFF)
Date: Sat, 18 Oct 2014 11:29:05 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RESEND PATCH v2 4/4] mac80211: minstrel_ht: add basic support
 for VHT rates <= 3SS@80MHz
References: <1413570896-27740-5-git-send-email-karl.beldan@gmail.com> <1413575459-29612-1-git-send-email-karl.beldan@gmail.com> <1413575459-29612-5-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1413575459-29612-5-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-10-17 21:50, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> When the new CONFIG_MAC80211_RC_MINSTREL_VHT is not set (default 'N'),
> there is no behavioral change including in sampling and MCS_GROUP_RATES
> remains 8.
> Otherwise MCS_GROUP_RATES is 10, and a module parameter *vht_only*
> (default 'true'), restricts the rates selection to VHT when vht is
> supported.
> 
> Regarding the debugfs stats buffer:
> It is explicitly increased from 8k to 32k to fit every rates incl. when
> both ht and vht rates are enabled, as for the format, before:
> type           rate     tpt eprob *prob ret  *ok(*cum)        ok(      cum)
> HT20/LGI ABCDP MCS0     0.0   0.0   0.0   1    0(   0)         0(        0)
> after:
>  type           rate      tpt eprob *prob ret  *ok(*cum)        ok(      cum)
>  HT20/LGI ABCDP MCS0      0.0   0.0   0.0   1    0(   0)         0(        0)
> VHT40/LGI       MCS5/2    0.0   0.0   0.0   0    0(   0)         0(        0)
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> Cc: Felix Fietkau <nbd@openwrt.org>
Aside from the module parameter issue that you already pointed out, the
series looks good to me.

- Felix
