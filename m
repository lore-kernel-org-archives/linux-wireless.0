Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLACK,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27994C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 11:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E16DE20851
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 11:14:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="CQ8spknN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E16DE20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbeKSVho (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 16:37:44 -0500
Received: from plaes.org ([188.166.43.21]:45964 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728557AbeKSVhn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 16:37:43 -0500
Received: from plaes.org (localhost [127.0.0.1])
        by plaes.org (Postfix) with ESMTPSA id 9112B40282;
        Mon, 19 Nov 2018 11:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542626063; bh=0aXq0jHH2dIIrN9BHuRRU2v7P8vIWouXCDJtrFzJZlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CQ8spknN404eVnSBpNSloUrPkTs7U7LWRoKVuivP4hIrf9IeGQyK/jDOUYpY0lPn/
         HW4Zf4cQnfXEju0v3TA3V9ZM50plw75Fa6J9Z5Yg19x7YFHMM66/w0E2aLKh6Do4tS
         8nj5ndmCZ++D1fe0nzWnV7Zw3qkR0y/R7S7PzP6btmKcaD+xoj/QBfc0+8AMc4SPhH
         G8DKWHU8Q36iq2UJ/PlXWHjL7qOqjMgl4N53iBDuV7RuczIjEkG9LwDQlvvTVvHcjt
         s2VcG3pmF8SVl+tDxdqBx+oKI8p4gAXoGMpZvJH/S/uqYv2JyW+KqG71LAEXX3tknl
         v1C3l2B5X2q4g==
Date:   Mon, 19 Nov 2018 11:14:22 +0000
From:   Priit Laes <plaes@plaes.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] b43: Use cordic algorithm from kernel library
Message-ID: <20181119111422.6vbxnmo4lgm6kl55@plaes.org>
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
 <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
 <d630ca3e-4070-5395-54c2-e20e0c552dc3@lwfinger.net>
 <20181118082327.ttrz2nl5owi2hoqv@plaes.org>
 <df798743-10bb-0455-be83-2fb59eca3209@lwfinger.net>
 <87lg5pcppn.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lg5pcppn.fsf@kamboji.qca.qualcomm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Nov 19, 2018 at 12:43:32PM +0200, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
> >>>> @@ -1570,10 +1571,10 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
> >>>>    	angle = 0;
> >>>>    	for (i = 0; i < len; i++) {
> >>>> -		samples[i] = b43_cordic(angle);
> >>>> +		samples[i] = cordic_calc_iq(angle);
> >>>>    		angle += rot;
> >>>> -		samples[i].q = CORDIC_CONVERT(samples[i].q * max);
> >>>> -		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
> >>>> +		samples[i].q = CORDIC_FLOAT(samples[i].q * max);
> >>>> +		samples[i].i = CORDIC_FLOAT(samples[i].i * max);
> >>>>    	}
> >>>>    	i = b43_nphy_load_samples(dev, samples, len);
> >>>
> >>> There is a fundamental flaw in this patch. Routine b43_cordic() takes an
> >>> angle in degrees scaled by 2^16, whereas cordic_calc_iq() takes an angle in
> >>> degrees. For a given input, the two routines must get different answers. At
> >>> a minimum, the calculation of rot would need to remove the left shift of 16.
> >>
> >> Thanks for the hint. I modified my "test harness" a bit to plot out values
> >> from -360 .. 360 and transformed the theta for b43_cordic argument
> >> using CORDIC_FIXED macro:
> >>
> >> b43_cordic(CORDIC_FIXED(theta));
> >> cordic_calc_iq(theta);
> >>
> >> Then I plotted the results and well.. they are not that pretty.
> >> While the results give
> >> identical answers between certain ranges of degrees, the cordic
> >> algorithm for b43 seems
> >> to be broken for certain ranges: (-270..-180 ; -90 .. 0; 90.. 180 and 270..360).
> >>
> >> You can find my test harnesses here:
> >>
> >> https://gist.github.com/plaes/284993a4fc65e0926d0628a11f0cf874
> >
> > I found a problem with the b43 implementation. The local variables for
> > that routine includes
> >
> >         u32 angle = 0;
> >
> > If one looks further down in the algorithm, if the reduced value of
> > "theta" is less than 0, then "angle" should be negative. That causes
> > the calculation to blow up. This explains why some ranges of angles
> > got the same result for both routines. When that declaration is
> > changed to "int angle = 0", the two routines give the same answer for
> > all inputs.
> >
> > My test setup has a hardware failure, thus I cannot test your patch,
> > but I now believe it to be correct. Thus your first and third patches
> > may be annotated with
> > ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
> >
> > One thing that should be done is to fix the error in the b43 code for
> > stable as it was introduced in 2.6.34. I propose adding the attached
> > patched to your series placed between your current 2nd and 3rd patches
> > so that the old kernels get fixed. Of course, your 3rd patch will need
> > to be revised. If all 4 of the patches get submitted together there
> > will be no problems with the timing. My change will exist for seconds
> > in the mainline kernel, but it will get propagated back through
> > stable.
> 
> Sorry Larry, I'm not fully understanding what you mean here. So I'm
> going to just drop the whole series and assume that Priit will submit a
> new version. Please let me know if I should do something else.

Yes, drop this one and I will submit v4 with one extra patch fixing the
cordic algorithm in the stable kernel.

> 
> -- 
> Kalle Valo
