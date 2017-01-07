Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33499 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755698AbdAGRgT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jan 2017 12:36:19 -0500
MIME-Version: 1.0
In-Reply-To: <CACna6rw22benfuw_7BSFw1wedavmMJWTo_hfPLCVa1t0kV+Aqg@mail.gmail.com>
References: <20170104175832.25996-1-zajec5@gmail.com> <20170104175832.25996-4-zajec5@gmail.com>
 <3fc87224-7f08-e365-7bbb-a4b8b5746e4f@broadcom.com> <CACna6rxay9sC+QT2G4AfjWT1ERsNDzFQ620hNhVhr0FRHXJu=w@mail.gmail.com>
 <e2bbce35-af09-adfa-09ea-e9fcf57b4d09@broadcom.com> <CACna6rw22benfuw_7BSFw1wedavmMJWTo_hfPLCVa1t0kV+Aqg@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Sat, 7 Jan 2017 18:36:17 +0100
Message-ID: <CACna6ryW9tvjRCTdOd3eGcajPSY9BTQp_6OVy6wYgBVhpsDr+Q@mail.gmail.com> (sfid-20170107_183624_060942_D5F49B3D)
Subject: Re: [PATCH V6 4/3] brcmfmac: use wiphy_read_of_freq_limits to respect
 extra limits
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 January 2017 at 11:02, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrot=
e:
> On 5 January 2017 at 10:31, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 4-1-2017 22:19, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> I'm not exactly happy with channels management in brcmfmac. Before
>>> calling wiphy_register it already disables channels unavailable for
>>> current country. This results in setting IEEE80211_CHAN_DISABLED in
>>
>> What do you mean by current country. There is none that we are aware off
>> in the driver. So we obtain the channels for the current
>> country/revision in the firmware and enable those before
>> wiphy_register(). This all is within the probe/init sequence so I do not
>> really see an issue. As the wiphy object is not yet registered there is
>> no user-space awareness
>
> It seems I'm terrible as describing my patches/problems/ideas :( Here
> I used 1 inaccurate word and you couldn't understand my point.
>
> By "current country" I meant current region (and so a set of
> regulatory rules) used by the firmware. I believe firmware describes
> it using "ccode" and "regrev".
>
> Now, about the issue I see:
>
> AFAIU if you set IEEE80211_CHAN_DISABLED in "orig_flags" it's meant to
> be there for good. Some reference code that makes me believe so
> (reg.c):
> pr_debug("Disabling freq %d MHz for good\n", chan->center_freq);
> chan->orig_flags |=3D IEEE80211_CHAN_DISABLED;
>
> This is what happens with brcmfmac right now. If firmware doesn't
> report some channels, you set "flags" to IEEE80211_CHAN_DISABLED for
> them. Then you call wiphy_register which copies that "flags" to the
> "orig_flags". I read it as: we are never going to use these channels.
>
> Now, consider you support regdom change (I do with my local patches).
> You translate alpha2 to a proper firmware request (board specific!),
> you execute it and then firmware may allow you to use channels that
> you marked as disabled for good. You would need to mess with
> orig_flags to recover from this issue.

I was wrong about this. Current notifier implementation in brcmfmac
doesn't care about "orig_flags" and it just sets "flags" as it wants.
This way it can enable even these channels that were believed to be
disabled for good (DISABLED in "orig_flags").

For my test I booted SR400ac with ccode & regrev set to values that
didn't allow me to use channels 149 - 165 (5735 - 5835). It matches my
current country:
country PL: DFS-ETSI
        (2402 - 2482 @ 40), (20)
        (5170 - 5250 @ 80), (20), AUTO-BW
        (5250 - 5330 @ 80), (20), DFS, AUTO-BW
        (5490 - 5710 @ 160), (27), DFS
        # 60 GHz band channels 1-4, ref: Etsi En 302 567
        (57000 - 66000 @ 2160), (40)

Then I used "iw reg set ??" to set country that allows these channels.
My locally modified brcmfmac driver sent proper "country" iovar to the
firmware and queried it for the updated "chanspecs". See my debugging
messages below:
brcmfmac: [brcmf_construct_chaninfo] hw_value:34 orig_flags:0x101 flags:0x0=
01
brcmfmac: [brcmf_construct_chaninfo] hw_value:36 orig_flags:0x1a0 flags:0x0=
a0
brcmfmac: [brcmf_construct_chaninfo] hw_value:38 orig_flags:0x101 flags:0x0=
01
brcmfmac: [brcmf_construct_chaninfo] hw_value:40 orig_flags:0x190 flags:0x0=
90
brcmfmac: [brcmf_construct_chaninfo] hw_value:42 orig_flags:0x101 flags:0x0=
01
brcmfmac: [brcmf_construct_chaninfo] hw_value:44 orig_flags:0x1a0 flags:0x0=
a0
brcmfmac: [brcmf_construct_chaninfo] hw_value:46 orig_flags:0x101 flags:0x0=
01
brcmfmac: [brcmf_construct_chaninfo] hw_value:48 orig_flags:0x190 flags:0x0=
90
brcmfmac: [brcmf_construct_chaninfo] hw_value:52 orig_flags:0x1aa flags:0x0=
aa
brcmfmac: [brcmf_construct_chaninfo] hw_value:56 orig_flags:0x19a flags:0x0=
9a
brcmfmac: [brcmf_construct_chaninfo] hw_value:60 orig_flags:0x1aa flags:0x0=
aa
brcmfmac: [brcmf_construct_chaninfo] hw_value:64 orig_flags:0x19a flags:0x0=
9a
brcmfmac: [brcmf_construct_chaninfo] hw_value:100 orig_flags:0x1aa flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:104 orig_flags:0x19a flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:108 orig_flags:0x1aa flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:112 orig_flags:0x19a flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:116 orig_flags:0x1aa flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:120 orig_flags:0x19a flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:124 orig_flags:0x1aa flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:128 orig_flags:0x19a flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:132 orig_flags:0x1aa flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:136 orig_flags:0x19a flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:140 orig_flags:0x1ba flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:144 orig_flags:0x101 flags:0x=
001
brcmfmac: [brcmf_construct_chaninfo] hw_value:149 orig_flags:0x101 flags:0x=
0a0
brcmfmac: [brcmf_construct_chaninfo] hw_value:153 orig_flags:0x101 flags:0x=
090
brcmfmac: [brcmf_construct_chaninfo] hw_value:157 orig_flags:0x101 flags:0x=
0a0
brcmfmac: [brcmf_construct_chaninfo] hw_value:161 orig_flags:0x101 flags:0x=
090
brcmfmac: [brcmf_construct_chaninfo] hw_value:165 orig_flags:0x101 flags:0x=
0b0

As you can see brcmfmac dropped IEEE80211_CHAN_DISABLED (hint: 0x1)
for channels 149 - 165 even though they were disabled according to the
"orig_flags".

So this patch with its
if (channel->orig_flags & IEEE80211_CHAN_DISABLED)
        continue;
could be considered some kind of regression. My change wouldn't allow
enabling such channels anymore.

Of course noone would notice this as noone uses country_codes table
yet I guess (except for me locally). Anyway, this patch should be
reworked to make sure it still allows implementing support for
country_codes tables in the future.
