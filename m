Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:44158 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZENEe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 00:34:57 -0400
Received: by pzk13 with SMTP id 13so454671pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 21:34:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
References: <1242030669.6930.10.camel@johannes.local> <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 13 May 2009 21:34:38 -0700
Message-ID: <43e72e890905132134v1f3f32f8p8dc73a09834100b4@mail.gmail.com>
Subject: Re: [RFT v9] rfkill: rewrite
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gaurav.Jauhar@atheros.com,
	Vivek Natarajan <vivek.natarajan@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2009 at 7:09 AM, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:
> On 5/11/09, Johannes Berg <johannes@sipsolutions.net> wrote:
>> This patch completely rewrites the rfkill core to address
>> the following deficiencies:
>
> Btw, git-apply nitpicks on your whitespace
>
> =C2=A0 =C2=A0rfkill-rewrite.patch:4335: space before tab in indent.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&rfkill_global_=
mutex);
> =C2=A0 =C2=A0warning: 1 line adds whitespace errors.
>
>
> I tested on todays wireless-testing, aka v2.6.30-rc5-23297-gbf2c6a3.
> Somehow, it triggers an OOPS
>
> Function: req_reg_info_regd
> Process: modprobe
>
> Call trace:
> wiphy_apply_custom_regulatory
> ath5k_regd_init
> ath5k_reg_notifier
> ath5k_pci_probe
> ...
>
> Photo: <http://picasaweb.google.com/sourcejedi.lkml/Screenshots#53349=
36857267342674>

BTW can explain how to reproduce. Did you just use wireless-testing
and johanne's rfkill rewrite and use ath5k and can easily reproduce?
Do you have an ath9k card?

  Luis

> The kernel then hangs later on in the boot process. =C2=A0It responds=
 to
> SysRq, but does not echo normal keypresses. =C2=A0SysRq+P shows that =
the
> kernel is in the idle task. =C2=A0I left it for three minutes, but I =
didn't
> get any trace from the hung task detector or soft lockup detector.
>
> At first I thought it must be a problem with wireless-testing.
> However, it went away when I eventually tried un-applying the rfkill
> rewrite patch.
>
> Thanks
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
