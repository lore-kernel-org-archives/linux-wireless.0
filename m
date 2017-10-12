Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdJLI5d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 04:57:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: Two rtlwifi drivers?
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
        <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
        <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
        <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
        <20171011131310.GF32250@kroah.com>
        <18efa551-f8fe-6bd2-71b9-69c867467db3@lwfinger.net>
Date: Thu, 12 Oct 2017 11:57:26 +0300
In-Reply-To: <18efa551-f8fe-6bd2-71b9-69c867467db3@lwfinger.net> (Larry
        Finger's message of "Wed, 11 Oct 2017 09:19:57 -0500")
Message-ID: <87d15spwuh.fsf@kamboji.qca.qualcomm.com> (sfid-20171012_105739_558669_C310E253)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 10/11/2017 08:13 AM, Greg Kroah-Hartman wrote:
>
>> On Wed, Oct 11, 2017 at 12:06:00PM +0300, Kalle Valo wrote:
>> I think it's horrid too.  But, if no one is able to do the real work
>> here, we hurt users who just need to use their hardware to get things
>> done.
>>
>> And it seems like the company isn't willing to do the real work, so
>> dumping this in staging is the best we can do at the moment.
>>
>> However, if this causes you problems, that's not good at all either.
>> Getting "real" support for this hardware is key, and hopefully can
>> happen somehow.  But fixing up the staging driver is almost never the
>> way to do it, as you know :)
>>
>> So what to do?  Any ideas?  What makes your life easier?  You can just
>> ignore the staging tree, as it should not affect your portion of the
>> kernel at all, right?
>
> Greg and Kalle,
>
> We can all agree that this situation is bad; however, several of the
> points made in your E-mails need to be addressed.
>
> First of all, I am not an employee of Realtek, and I have no knowledge
> of the internals of any of their chips. I have never signed a
> non-disclosure agreement, and the only thing that I have received from
> them are sample chips for testing. My main interest is in helping the
> user experience.

And you are doing a great job at that! My only gripe here is forking the
driver.

> As there are a number of users with the new RTL8822BE device, that
> meant getting an in-kernel driver to them as soon as possible. As
> stated earlier, adding this particular device to the rtlwifi family
> involved roughly 120K lines of new code. Given our recent experience
> in getting code accepted into the wireless tree meant that this
> additional code would not have been accepted for many months. For that
> reason, we chose the staging route. It is important that we get this
> right as Realtek tells me that there will be two additional new
> drivers in the coming 6 months.

If there are new drivers coming in 6 months they should submitting
patches already now, this is my main point. Don't work in a waterfall
model, release early and release often.

> As to the convergence of the rtlwifi code between staging and
> wireless, I applied the 40 or 50 patches in my queue to the wireless
> version to create the version that went into staging. If any of the
> current patches to wireless do not seem to be in the staging version,
> sometimes temporary changes are necessary so that the intermediate
> drivers will build and work. Yes, it is code churn, but necessary to
> keep patches small. In keeping with Kalle's requests, only a fraction
> of those patches have been submitted to him.
>
> My intent is to have the RTL8822BE driver moved from staging to
> mainline no later than 4.17. The affected drivers rtl_pci, rtlwifi and
> becoex will be moved in that order. Of course, the required changes
> will need to be in wireless before staging is changed, which will slow
> the process.

Great to hear that you will be working on that. But yeah, that's quite
an effort. IMHO a lot more work than if you would be working only with
drivers/net/wireless.

> As I see it, the switch can only occur with a new version.

Yeah, we need to be very careful with the switch so that we don't break
existing setups.

> My opinion is that the company has gone a long ways toward meeting the
> requirements of the Linux kernel. A lot of their code is written for
> Windows and Linux, with emphasis on Windows, which complicates matters
> as not all of the changes for Linux can be backported.

I think all vendors had these huge OS agnostic drivers before: TI,
Atheros/QCA etc. So it's not really a new thing and still most of the
companies have been able to adapt one way or another.

> Prior to the introduction of these drivers in 2.6.38, drivers were
> released periodically as tar files with no information regarding
> intermediate steps were recorded other than the SVN modification
> number. At least now, we get relatively small changes.

Yes, the changes might be small but to me it seems Realtek still dumps
them in one big release. That's the problem here.

> I have been pleased and surprised at the stability and performance of
> the driver in staging. Other than possible changes required by
> reviewers when it is moved, it is ready for the wireless tree.
>
> Finally, I have notified my Realtek contact that I do not plan to
> continue as the maintainer of these drivers very much longer due to my
> age. I still have the interest, but not always the energy. The people
> at Realtek have proposed a plan that seems workable. Of course, there
> will be hiccups, but the current process does not seem to be that
> smooth.

Sorry to hear that you are stepping down as the maintainer but it's
undertandable as you have had so much work to do. But I hope you still
stick around.

-- 
Kalle Valo
