Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:53055 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZC1DB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 23:01:26 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1554271rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 20:01:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090328022659.GD5543@bombadil.infradead.org>
References: <20090323162834.154525349@sipsolutions.net> <20090323163052.823346545@sipsolutions.net>
	<20090328022659.GD5543@bombadil.infradead.org>
Date: Fri, 27 Mar 2009 20:01:09 -0700
Message-ID: <43e72e890903272001h3e2fb2f0yf6a150f5e22d7039@mail.gmail.com> (sfid-20090328_040127_921376_1E36F058)
Subject: Re: [PATCH 5/8] mac80211: unify and fix TX aggregation start
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 27, 2009 at 7:27 PM, Luis R. Rodriguez
<mcgrof@bombadil.infradead.org> wrote:
> On Mon, Mar 23, 2009 at 05:28:39PM +0100, Johannes Berg wrote:
>> When TX aggregation becomes operational, we do a number of steps:
>> =C2=A01) print a debug message
>> =C2=A02) wake the virtual queue
>> =C2=A03) notify the driver
>>
>> Unfortunately, 1) and 3) are only done if the driver is first to
>> reply to the aggregation request, it is, however, possible that the
>> remote station replies before the driver! Thus, unify the code for
>> this and call the new function ieee80211_agg_tx_operational in both
>> places where TX aggregation can become operational.
>>
>> Additionally, rename the driver notification from
>> IEEE80211_AMPDU_TX_RESUME to IEEE80211_AMPDU_TX_OPERATIONAL.
>>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> Nice catch man!
>
> Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Hm, maybe also a backported version could go to stable? Perhaps we can
trigger a panic on a UP box?

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
