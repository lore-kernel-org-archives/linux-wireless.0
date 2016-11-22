Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754435AbcKVPBr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 10:01:47 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Barry Day <briselec@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Fix failure to reconnect to AP
References: <20161113111705.GA2393@box64.home.org>
        <wrfjoa1iyz1e.fsf@redhat.com> <wrfjbmx87oul.fsf@redhat.com>
        <20161122125300.GB23278@testbox>
Date: Tue, 22 Nov 2016 10:01:45 -0500
In-Reply-To: <20161122125300.GB23278@testbox> (Barry Day's message of "Tue, 22
        Nov 2016 22:53:01 +1000")
Message-ID: <wrfjzikr4kyu.fsf@redhat.com> (sfid-20161122_160150_571444_E33F29B1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Barry Day <briselec@gmail.com> writes:
> On Mon, Nov 21, 2016 at 11:57:22AM -0500, Jes Sorensen wrote:
>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>> >>  void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
>> >> @@ -4515,6 +4523,8 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>> >>  				sgi = 1;
>> >>  			rcu_read_unlock();
>> >>  
>> >> +			rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0xffff);
>> >> +
>> >>  			priv->fops->update_rate_mask(priv, ramask, sgi);
>> >>  
>> >>  			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
>> 
>> I believe this change only matters because you disable RXFLTMAP2
>> above. If we really have to write to RXFLTMAP2 to make this work, I
>> suspect we need to keep some sort of state information.
>> 
>> I would also be curious if RXFLTMAP2 gets reset somehow by the firmware,
>> and we do not account for that.
>> 
>> Cheers,
>> Jes
>
> I'll redo the patch without touching REG_RXFLTMAP2. I don't think it's needed
> to fix the fail to reconnect issue.
>
> I haven't had a proper look at the 8723 chips yet but the vendor drivers for
> the others don't do a h2c cmd for disconnect but I'll test leaving it in to see
> if it makes any difference. A 8723bu arrived in the mail today so now I can
> test it too and I discovered yesterday I have a 8723au but it's in a cheap
> Android tablet.

Let me know what you find out - if the h2c command causes the failure
that would be very bizarre but certainly interesting to learn.

Cheers,
Jes
