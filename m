Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:44280 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab2BBQGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 11:06:54 -0500
Received: by wibhq12 with SMTP id hq12so2802743wib.35
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 08:06:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F277FE3.8090006@sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-5-git-send-email-victorg@ti.com>
	<4F277FE3.8090006@sipsolutions.net>
Date: Thu, 2 Feb 2012 18:06:52 +0200
Message-ID: <CAK80WHaiOp2f08ErSiLdoSOcN1A1EbFX4x02wGPQY1WJJrKK-g@mail.gmail.com> (sfid-20120202_170658_274803_836BF79A)
Subject: Re: [RFC 4/9] mac80211: add ability to enable TX on op-channel
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 7:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On 1/26/2012 4:37 AM, Victor Goldenshtein wrote:
>>
>> Prior starting tx on DFS channels, the DFS master
>> device shall perform a Channel Availability Check
>> to ensure that there is no radar interference on
>> those channels. Once CAC done, the tx can be
>> enabled with ieee80211_dfs_en_tx().
>
>
> How do you expect this to be used by the device? It seems that it should
> have the side effect of lifting some TX-prohibited flag instead?

In wl12xx driver we starting the AP role, and clearing FLAG_DFS_CAC_IN_PROGRESS.
Maybe the function name is misleading here ? maybe we should rename it
to something like resume_dfs_cac() - because it is called at the end
of the CAC test.

The other question is whether we want to add DFS flags into mac? I
mean something like FLAG_DFS_CAC_IN_PROGRESS.

-- 
Thanks,
Victor.
