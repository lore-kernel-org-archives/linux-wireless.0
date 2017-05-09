Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:34639 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdEIXDQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 19:03:16 -0400
Received: by mail-pg0-f50.google.com with SMTP id u28so6874949pgn.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 16:03:16 -0700 (PDT)
Date: Tue, 9 May 2017 16:03:12 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Eyal Ilsar <c_eilsar@qti.qualcomm.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] wcn36xx: Close SMD channel on device removal
Message-ID: <20170509230312.GR15143@minitux> (sfid-20170510_010340_327924_C2D7006D)
References: <20170509043637.28179-1-bjorn.andersson@linaro.org>
 <87h90u3672.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87h90u3672.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon 08 May 23:17 PDT 2017, Kalle Valo wrote:

> Bjorn Andersson <bjorn.andersson@linaro.org> writes:
> 
> > The SMD channel is not the primary WCNSS channel and must explicitly be
> > closed as the device is removed, or the channel will already by open on
> > a subsequent probe call in e.g. the case of reloading the kernel module.
> >
> > This issue was introduced because I simplified the underlying SMD
> > implementation while the SMD adaptions of the driver sat on the mailing
> > list, but missed to update these patches. The patch does however only
> > apply back to the transition to rpmsg, hence the limited Fixes.
> >
> > Fixes: 5052de8deff5 ("soc: qcom: smd: Transition client drivers from smd to rpmsg")
> > Reported-by: Eyal Ilsar <c_eilsar@qti.qualcomm.com>
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> As this is a regression I'll queue this to 4.12.
> 

Thanks.

> But if this is an older bug (didn't quite understand your description
> though) should there be a separate patch for stable releases?
> 

AFAICT this never worked, as it seems I did the rework in SMD while we
tried to figure out the dependency issues we had with moving to SMD. So
v4.9 through v4.11 has SMD support - with this bug.

How do I proceed, do you want me to write up a fix for stable@? Do I
send that out as an ordinary patch?

Regards,
Bjorn
