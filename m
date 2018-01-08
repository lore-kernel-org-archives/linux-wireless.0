Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:64933 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756239AbeAHMYo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 07:24:44 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Daniel Drake <drake@endlessm.com>
CC: Russell Hu <rhu@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        "Robert Chang" <rwchang@qti.qualcomm.com>,
        Aeolus Yang <aeolus@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "andy@infradead.org" <andy@infradead.org>,
        "acelan.kao@canonical.com" <acelan.kao@canonical.com>
Subject: Re: [v2] ath9k: add MSI support
Date: Mon, 8 Jan 2018 12:24:34 +0000
Message-ID: <87bmi45yim.fsf@kamboji.qca.qualcomm.com> (sfid-20180108_132448_211377_B72D16A7)
References: <20171110025415.7854-1-drake@endlessm.com>
        <87y3na7eei.fsf@qca.qualcomm.com>
        <CAD8Lp47uJbB27xZPH3dDqNuJcaNCGEsbpdqfK-h4+nzVLGk1aw@mail.gmail.com>
        <87bmk5hx9x.fsf@kamboji.qca.qualcomm.com>
        <CAD8Lp455GLxVHves8gNbfm9dMUmhj1DOMyeiOk5Td7m2rAxYFA@mail.gmail.com>
        <CAD8Lp44BWhK7j5dKzHqqXTaR4uG9=-6oJd2NEsdM8oQYw0D8Bw@mail.gmail.com>
In-Reply-To: <CAD8Lp44BWhK7j5dKzHqqXTaR4uG9=-6oJd2NEsdM8oQYw0D8Bw@mail.gmail.com>       (Daniel
 Drake's message of "Tue, 12 Dec 2017 11:43:15 +0000")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding AceLan)

Daniel Drake <drake@endlessm.com> writes:

> On Wed, Nov 15, 2017 at 7:38 AM, Daniel Drake <drake@endlessm.com> wrote:
>> On Tue, Nov 14, 2017 at 8:15 PM, Kalle Valo <kvalo@qca.qualcomm.com> wro=
te:
>>>> Can't be fixed in firmware, but it would be good to have confirmation
>>>> of the hardware behavivour, and maybe some other solution is possible?
>>>> Are you following this up within Qualcomm?
>>>
>>> No time to do that right now, sorry.
>>
>> I got several autoresponders from people on this thread from Qualcomm
>> Taiwan. Would it be useful for us to drop off a sample of the affected
>> product at your Taipei or Hsinchu office so that you can investigate
>> further?
>
> Ping - how can we collaborate on this?

Are you asking me? While looking at my todo list for this year I doubt I
can find time to help with the MSI implementation or bugfixing.

But my plan is that first I would apply Russel's patch which makes it
possible to enable MSI with a module parameter:

https://patchwork.kernel.org/patch/9999249/

Then if AceLan could rebase the quirk patches and resubmit those so that
I can apply those:

https://patchwork.kernel.org/patch/9971097/
https://patchwork.kernel.org/patch/9971095/
https://patchwork.kernel.org/patch/9971093/
https://patchwork.kernel.org/patch/9971091/
https://patchwork.kernel.org/patch/9971089/

Also I don't see the need to have five different patches for the quirks,
having just one patch adding all those should be ok.

Are everyone happy with this plan?

> Also, we have been testing the MSI support patch and while it seems to
> be working fine on AR9565, multiple users hit failures on AR9462. The
> most common report is that the system simply cannot maintain the
> connection with the AP for more than a few seconds. It hits a check in
> mac80211 where it sends a nullfunc to the AP and expects an ack in
> less than 500ms, but it disconnects since it doesn't see the ack.
>
> https://marc.info/?l=3Dlinux-wireless&m=3D151027741010422&w=3D2
>
> We also reproduced a problem in our office with AR9462. With the MSI
> support patch in use, we ping a server every second for 1000 seconds
> while monitoring "iw dev wlp2s0 link" output. With the MSI support
> patch in place, this test fails every time; the connection is dropped
> in less than 1000s.
> With the patch reverted everything is fine.

I'm not really surprised and this is exactly why I was against of
enabling MSI by default. It can cause all sorts of weird problems.

--=20
Kalle Valo=
