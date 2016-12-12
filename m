Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57737 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751640AbcLLOHn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 09:07:43 -0500
Date: Mon, 12 Dec 2016 15:07:39 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
Subject: Re: Could we have request_firmware_nowait with FW_OPT_NO_WARN?
Message-ID: <20161212140739.GB1402@wotan.suse.de> (sfid-20161212_150804_467929_DFA7B16B)
References: <CACna6rxOGo0e9U7eXpUgnnBuxL+x1B0JBf9ZBq2WPbaBE=YZ-g@mail.gmail.com>
 <1481530339.4067.1.camel@sipsolutions.net>
 <CACna6rzZnO1YtS2=6S1PGCTJkzTeuz9oJ+1yHBgWNhvUPz4acg@mail.gmail.com>
 <815a15b6-f22d-8c45-f76c-2c756f159366@broadcom.com>
 <CACna6rzF3=A_FT6QBiO8_uDE5-Ey-AD-Gfh0OU+Z1G_N_fKv-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzF3=A_FT6QBiO8_uDE5-Ey-AD-Gfh0OU+Z1G_N_fKv-A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 12, 2016 at 10:53:38AM +0100, Rafał Miłecki wrote:
> On 12 December 2016 at 10:26, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
> > On 12-12-2016 9:32, Rafał Miłecki wrote:
> >> On 12 December 2016 at 09:12, Johannes Berg <johannes@sipsolutions.net> wrote:
> >>> On Sat, 2016-12-10 at 16:54 +0100, Rafał Miłecki wrote:
> >>>> In brcmfmac we use request_firmware_nowait and if fetching firmware
> >>>> with NVRAM variables fails then we try to fallback to the platform
> >>>> one (see brcmf_fw_request_code_done & brcmf_fw_request_nvram_done).
> >>>>
> >>>> Some problem for us is that on devices with platform NVRAM we get
> >>>> this error:
> >>>> Direct firmware load for brcm/brcmfmac43602-pcie.txt failed with error -2
> >>>
> >>> This also happens with iwlwifi, because it requests multiple firmware
> >>> versions starting at the most recent supported one (which is often not
> >>> released at the same time).
> >>
> >> Good to know it may help others as well!
> >>
> >>
> >>> So yeah, this would be really useful - why don't you just make a patch
> >>> with some kind of flags, whether it's FW_OPT_* or new flags?
> >>
> >> OK! If noone will come with any special comments/ideas soon, I'll
> >> propose a patch for using some flags.
> >>
> >> FWIW, meanwhile I submitted
> >> [PATCH V2] firmware: simplify defining and handling FW_OPT_FALLBACK
> >> https://patchwork.kernel.org/patch/9469875/
> >
> > Similar thread couple of months ago [1]
> >
> > (...)
> >
> > [1] http://lists.infradead.org/pipermail/ath10k/2016-July/thread.html#8026
> 
> Oh, now I see it's a bit messy topic and not clearly maintained class.
> It seems more ppl were confused by the API. I think having many
> unrelated behavior bounded to few functions caused some of this
> confusion. Let's hope adding some flags will let us use function the
> way they were designed, I'll definitely try working on this.

4.9 was just released, this means the merge window opened and no functional
changes will be merged for a while. I'll revamp my new API whcih would allow
what you describe to be an add-on flag without having to extend the API with
yet another series of exported symbols just for a new option. I'll also
CC you on a documentation revamp because as you note its much needed.

  Luis
