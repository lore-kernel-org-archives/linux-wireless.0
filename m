Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65331 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab1I1Twf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 15:52:35 -0400
Received: by qyk30 with SMTP id 30so2723202qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2011 12:52:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E834128.2030208@neratec.com>
References: <CAB=NE6UcT8gzVWW+stLEy2SKBCdt-wVnv6aWOZBKTurXk1W0YA@mail.gmail.com>
 <4E834128.2030208@neratec.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 28 Sep 2011 12:52:15 -0700
Message-ID: <CAB=NE6U6qmYbvHPTWGTqOdXtuxbKYbUzZXNiE6POOX9QZNRWAg@mail.gmail.com> (sfid-20110928_215240_051656_82F30AE3)
Subject: Re: Regulatory revamp status
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	"Green, Michael" <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	"Venkataraman, Arun" <arunvenk@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Presman, Boris" <boris.presman@ti.com>,
	"Azulay, Assaf" <assaf@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 28, 2011 at 8:45 AM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> Hello Luis,
>
> I am referring to your announcement for a regulatory revamp at the LinuxWireless
> summit in Vancouver and the patches to add DFS information to CRDA you
> proposed quite some time ago in [1].
>
> For the integration of DFS that is currently being worked out by TI, we will need to have
> the DFS regulatory domain for the selected countrycode available -- that basically was
> implemented with the named patch set.

Yup, there was one pending item on that and it was to determine
whether or not a country can have different DFS regions for different
frequency bands. If this is true this also implies that a country can
have multiple DFS regions. I have found one country in our internal
regulatory updates which maps Bulgaria to different DFS regions and
have asked our regulatory folks about this. This seems odd to me and
I'd prefer to stick to one DFS region entirely for one country, but if
in the future we forsee DFS regions to be band specific this may
complicate things and we should address this now. Can you tell me if
at TI you have no multiple DFS regions for one country ? Do you guys
have Bulgaria mapping to one DFS region?

> Could you please give some info on the status of the regulatory revamp and particularly if
> the proposed DFS information will be part of it?

You should consider DFS integration into wireless-regdb as independent
of the regulatory revamp given that we have 16 bits we can use to
extend wireless-regdb for any future capabilities without having to
restructure the format of the file to require a different version of
crda. So DFS can be added as-is today. Updates below on the regulatory
revamp though and DFS.

I'm chugging along the regulatory revamp slowly given the questions
that come up with it require consulting with several different people.
The latest piece I reviewed was TPC and for that it seems we already
take into account the 3 dB difference into account into
wireless-regdb, however this can be further optimized if TPC is
implemented -- but implementing TPC is device specific in that the TPC
reports and how you use them can vary depending on the device. When
you send TPC report requests will also vary. In short I've latest
determined to stick to what we have today and assume we'll always be
reducing the 3 dB in power built-in already into the wireless-regdb
power for each country where needed. This assumes no proper TPC
implementation. It would still be nice to know when a band requires
TPC though to enable vendors to implement TPC and reduce power not by
3 dB but by whatever metrics they come up with. Given that 3 dB seems
to be the only required change we likely could stick to that as the
assumed max value and just require a TPC flag, and if the band has
this flag allow the driver / stack / etc to add 3 dB more to power if
it implements TPC. The only problem with this is we'd assume alway a
static 3 dB. Another possibility is to use a u8 value here to
represent the deducted tx power, instead of a bit value for a flag.

Technically speaking we can support both DFS and TPC in the current
file format for wireless-regdb, we have 16 bits left, we could leave
u8 for DFS region as a bitmask (left to determine about the multiple
DFS regions) and u8 for the tx power adaptation for TPC. Thoughts?

> One detail that came up in the discussion to
> your patches was whether DFS regulatory domains are constant for a countrycode or might
> differ between bands. Has this been clarified meanwhile?

Not yet! I've asked for input a while ago and today as well. What do
you guys think?

  Luis
