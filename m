Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40391 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab1KWO6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 09:58:22 -0500
Received: by vcbfk14 with SMTP id fk14so391519vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 06:58:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111123144258.GC2502@tuxdriver.com>
References: <201111230330.11103.tlnd@online.de> <CAB=NE6U6ru-xns8M+YUccqxw0FwE-sWtZnFkPUud3jHdAcDxsw@mail.gmail.com>
 <20111123143456.GB2502@tuxdriver.com> <20111123144258.GC2502@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Wed, 23 Nov 2011 06:58:00 -0800
Message-ID: <CAB=NE6WtBH+jpi3AVAdn2ZTZFPYMx6y73bneTEquZaGbuUJizQ@mail.gmail.com> (sfid-20111123_155826_159357_7DD4A73C)
Subject: Re: [PATCH] cfg80211: Fix changing regulatory from userspace
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Timo Lindhorst <tlnd@online.de>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2011 at 6:42 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Nov 23, 2011 at 09:34:56AM -0500, John W. Linville wrote:
>> On Wed, Nov 23, 2011 at 06:28:57AM -0800, Luis R. Rodriguez wrote:
>> > On Tue, Nov 22, 2011 at 6:30 PM, Timo Lindhorst <tlnd@online.de> wrote:
>> > > The commit de3584bd62d87b4c250129fbc46ca52c80330add -
>> > > "cfg80211: fix regulatory NULL dereference" prevents the regulatory
>> > > domain from being changed by user space. A wiphy is only present
>> > > if the request comes from driver or is set by country IE, thus
>> > > check only those cases.
>> > >
>> > > Signed-off-by: Timo Lindhorst <tlnd@online.de>
>> >
>> > Yup but at this point I'd prefer we revert the original patch instead
>> > given that the patch also had some other short comings. John is it too
>> > late?
>>
>> No, it isn't too late to revert it.  But can we have a new fix soon?
>
> Hmmm...actually, the original patch was sent in the batch yesterday.
> And it was Cc: stable.  It would be a lot less confusing to merge a
> correct fix on top (and Cc: stable on that too).  What is wrong with
> this one?

This one is a correct fix to one of the issues present in the original
patch, the other issue is the original patch overlooks the fact that
last_request would be left with stale data. Let me post my fixes as
RFCs on top of Johannes's original patch to clarify. Unfortunately
this doesn't have much testing but I'll post for review at least.

  Luis
