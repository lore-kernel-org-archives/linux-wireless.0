Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36045 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYJGR42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 13:56:28 -0400
Message-ID: <48EBA2BE.9070705@openwrt.org> (sfid-20081007_195632_134041_62F1CCB5)
Date: Tue, 07 Oct 2008 19:56:14 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 2/4] mac80211: add multi-rate retry support
References: <48E8E48E.5090300@openwrt.org> <48E8E528.7060501@openwrt.org>	 <48E8E588.30001@openwrt.org> <1223329786.3778.38.camel@johannes.berg>	 <48EB98A6.4050406@openwrt.org> <1223400436.7328.54.camel@johannes.berg>
In-Reply-To: <1223400436.7328.54.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2008-10-07 at 19:13 +0200, Felix Fietkau wrote:
>> Johannes Berg wrote:
>> > On Sun, 2008-10-05 at 18:04 +0200, Felix Fietkau wrote:
>> >> This patch adjusts the rate control API to allow multi-rate retry
>> >> if supported by the driver. The ieee80211_hw struct specifies how
>> >> many alternate rate selections the driver supports.
>> > 
>> > Don't those drivers that announce supporting max_altrates = 1 have to
>> > update the status for alternative rates too? Also, should
>> > max_altrate_tries == 0 indicate that that is fixed?
>> IMHO yes.
> Should we document that?
Maybe ;)

>> The IEEE80211_TX_CTL_RATE_CTRL_PROBE flag is used to tell the tx_status
>> function that there is a sampling rate in the second MRR stage, so that
>> it can update the sampling counter accordingly, in case the sampling rate
>> actually got used.
> So if I read that correctly you're saying it's not part of the driver
> API but just something to be preserved from tx to tx-status. Can you
> document that in the header file too please?
Will send a new patch updating the docs soon. Should that hint apply to
only this particular flag or the whole flags struct member?

- Felix
