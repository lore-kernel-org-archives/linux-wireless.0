Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:43660 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdLLLnQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 06:43:16 -0500
Received: by mail-oi0-f52.google.com with SMTP id f69so13777504oig.10
        for <linux-wireless@vger.kernel.org>; Tue, 12 Dec 2017 03:43:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD8Lp455GLxVHves8gNbfm9dMUmhj1DOMyeiOk5Td7m2rAxYFA@mail.gmail.com>
References: <20171110025415.7854-1-drake@endlessm.com> <87y3na7eei.fsf@qca.qualcomm.com>
 <CAD8Lp47uJbB27xZPH3dDqNuJcaNCGEsbpdqfK-h4+nzVLGk1aw@mail.gmail.com>
 <87bmk5hx9x.fsf@kamboji.qca.qualcomm.com> <CAD8Lp455GLxVHves8gNbfm9dMUmhj1DOMyeiOk5Td7m2rAxYFA@mail.gmail.com>
From: Daniel Drake <drake@endlessm.com>
Date: Tue, 12 Dec 2017 11:43:15 +0000
Message-ID: <CAD8Lp44BWhK7j5dKzHqqXTaR4uG9=-6oJd2NEsdM8oQYw0D8Bw@mail.gmail.com> (sfid-20171212_124320_589370_2AACA6CD)
Subject: Re: [v2] ath9k: add MSI support
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Russell Hu <rhu@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Robert Chang <rwchang@qti.qualcomm.com>,
        Aeolus Yang <aeolus@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "andy@infradead.org" <andy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 15, 2017 at 7:38 AM, Daniel Drake <drake@endlessm.com> wrote:
> On Tue, Nov 14, 2017 at 8:15 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Can't be fixed in firmware, but it would be good to have confirmation
>>> of the hardware behavivour, and maybe some other solution is possible?
>>> Are you following this up within Qualcomm?
>>
>> No time to do that right now, sorry.
>
> I got several autoresponders from people on this thread from Qualcomm
> Taiwan. Would it be useful for us to drop off a sample of the affected
> product at your Taipei or Hsinchu office so that you can investigate
> further?

Ping - how can we collaborate on this?

Also, we have been testing the MSI support patch and while it seems to
be working fine on AR9565, multiple users hit failures on AR9462. The
most common report is that the system simply cannot maintain the
connection with the AP for more than a few seconds. It hits a check in
mac80211 where it sends a nullfunc to the AP and expects an ack in
less than 500ms, but it disconnects since it doesn't see the ack.

https://marc.info/?l=linux-wireless&m=151027741010422&w=2

We also reproduced a problem in our office with AR9462. With the MSI
support patch in use, we ping a server every second for 1000 seconds
while monitoring "iw dev wlp2s0 link" output. With the MSI support
patch in place, this test fails every time; the connection is dropped
in less than 1000s.
With the patch reverted everything is fine.

We ran the same test with AR9565 in MSI mode and it worked fine.

Daniel
