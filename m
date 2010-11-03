Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63709 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab0KCDQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 23:16:15 -0400
Received: by yxk8 with SMTP id 8so157046yxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 20:16:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CCEE9C9.3090308@lwfinger.net>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com>
	<4C798080.8010002@lwfinger.net>
	<20100830141218.GB30864@tuxdriver.com>
	<4C7BC4D9.1010108@lwfinger.net>
	<20100830152841.GB2950@barata.holoscopio.com>
	<loom.20101026T200014-691@post.gmane.org>
	<4CC71CFF.8050004@lwfinger.net>
	<20101026185341.GA4608@barata.holoscopio.com>
	<20101028191305.2960c83b@gotham.conectiva>
	<loom.20101029T010426-834@post.gmane.org>
	<20101029135449.GB3768@barata.holoscopio.com>
	<loom.20101030T001241-932@post.gmane.org>
	<4CCE4479.1010400@mandriva.com.br>
	<4CCEE9C9.3090308@lwfinger.net>
Date: Wed, 3 Nov 2010 01:16:14 -0200
Message-ID: <AANLkTinSo_ZsMgwCJcSW=u17FuWBz8EWsbjU2oOKZ=vq@mail.gmail.com>
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
From: Rogerio Luz Coelho <rogluz.news@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	seno <senada@t-online.de>, linux-wireless@vger.kernel.org,
	hintak.leung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok I thought I got something wrong when I reviewed the thread I was
reading, this hole thread was in my trash folder (who would figure)

Will post results

Rogerio

2010/11/1 Larry Finger <Larry.Finger@lwfinger.net>:
> On 10/31/2010 11:39 PM, Herton Ronaldo Krzesinski wrote:
>> I have seen the throughput issue, but on my tests it wasn't so bad.
>> Usually max I got on testing was 24M while close to the AP, and it goes
>> into lower speeds when going more far away, but takes a good number of
>> meters to go down to 1M.
>>
>> Anyway of course something isn't right. I started reviewing realtek GPL
>> code (their ieee80211 drivers) and code in rtl8187 in the kernel, doing
>> many tests and verifying things, trying to understand and check some
>> register writes etc. (hard with missing doc or other info).
>>
>> I did some cleanups, and discovered two bad things in the code. After
>> the fixes, I can get normal rates (up to 54M close to the AP) without
>> issue. I'll soon post the patch series to be included in
>> wireless-testing, for now just for test I attach them to be easier (hope
>> it isn't stripped by ML, and yes they start on 0003 through 0011 :P),
>> check if with it you get better results.
>>
>> The patches that matter (shown by my tests) are:
>> 0010-rtl8187-remove-uneeded-setting-of-anaparam-write.patch
>> 0011-rtl8187-restore-anaparam-registers-after-reset-with-.patch
>>
>> but they depend on some previous patches in the series (better apply
>> all), and I diffed on a tree with Thadeu's patch applied already. There
>> is more cleanups and checking to do, but I probably will submit this
>> initial series and later come with more ones, as with this initial
>> series the throughput issue should be solved.
>
> Good work. As you noted, patches 3 - 9 did not make any difference in the
> transmit throughput. From a distance of 2 m from the AP, my 8187B yielded up to
> 11.4 Mb/s and an indicated rate of 24 M. Applying patch 10 raised those numbers
> to 17.5 Mb/s and 48 M. Adding patch 11 raised them again to 26.9 Mb/s and 54 M,
> thus getting full throughput for the 8187B and a transmit rate increase of 2.4X.
>
> As expected, these changes had no affect on the RTL8187L. Note: The 8187L gets
> values of 23.0 Mb/s and 54M - there may be a little performance gain to be
> obtained from the driver.
>
> You should submit these patches now, and feel free to add my "Acked-by:" to them.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
