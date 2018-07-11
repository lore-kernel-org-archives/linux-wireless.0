Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:36206 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389438AbeGKV6Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 17:58:24 -0400
Received: by mail-pl0-f67.google.com with SMTP id a7-v6so9726274plp.3
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2018 14:52:02 -0700 (PDT)
Date: Wed, 11 Jul 2018 14:51:59 -0700
From: Brian Norris <briannorris@chromium.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        david.brown@linaro.org, andy.gross@linaro.org,
        niklas.cassel@linaro.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/6] *** Add support for wifi QMI client handshakes ***
Message-ID: <20180711215158.GA161212@ban.mtv.corp.google.com> (sfid-20180711_235205_985015_61E8D7EF)
References: <20180706085622.27945-1-govinds@codeaurora.org>
 <20180711012638.GA100410@ban.mtv.corp.google.com>
 <20180711022425.GI2050@tuxbook-pro>
 <0b1441507d2bb18ae267af65e13d98ec@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0b1441507d2bb18ae267af65e13d98ec@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Jul 11, 2018 at 10:31:43AM +0530, Govind Singh wrote:
> On 2018-07-11 07:54, Bjorn Andersson wrote:
> > On Tue 10 Jul 18:26 PDT 2018, Brian Norris wrote:
> > > On Fri, Jul 06, 2018 at 02:26:17PM +0530, Govind Singh wrote:
> > [..]
> > > > https://github.com/andersson/tqftpserv
> > > 
> > > FWIW, as of today, the tqftpserv implementation is missing a few
> > > headers
> > > (so it doesn't even build),
> > 
> > Sorry about that, had those lingering in my repository. I've pushed a
> > fix for this.
> > 
> > > and once I hack things such that it can
> > > build, it still doesn't work for me (whereas the closed source version
> > > does). I see some BYE and DEL_CLIENT messages, but no read requests.
> > 
> > I interpret this description as you're not seeing any prints at, beyond
> > the "[TQFTP] got bye" and "[TQFTP] got del_client"?

Yes, I thought that was the case.

> > That would imply that the remote side doesn't even attempt to
> > communicate with tqftpserv.
> > 
> > Are you running pd-mapper (either proprietary or my version), is it
> > complaining about anything?
> > 
> > Can you run qrtr-lookup on the device after booting the modem? So that
> > we see that the tqftpserv is registered properly and that the modem is
> > in an appropriate state?
> > 
> > Regards,
> > Bjorn
> 
> For me below sequence is working. PD mapper is bypassed in the modem binary
> that Brian is using, hence that
> may not be required at this moment.
> 
> 
> qrtr-cfg 1
> qrtr-ns

I already had those taken care of.

> mkdir -p /dev/block/bootdevice/by-name/
> ln -s /dev/sda4 /dev/block/bootdevice/by-name/modemst1
> ln -s /dev/sda5 /dev/block/bootdevice/by-name/modemst2
> ln -s /dev/sda6 /dev/block/bootdevice/by-name/fsc
> ln -s /dev/sda7 /dev/block/bootdevice/by-name/fsg

The above are all irrelevant and possibly dangerous.

> ln -s /var/log/ /readwrite
> ln -s /lib/firmware/wlanmdsp.mbn /readonly/firmware/image/wlanmdsp.mbn

Somehow I missed these; perhaps I was somehow filtering out the console
complaints where the server couldn't write to /readwrite/..., but once I
have these /readwrite and /readonly paths set up, it does indeed work.

BTW, it's a bit of an annoyance here that the Q6 requires having write
access to arbitrary files on the host side. At least now that I have
source code for this wretched server, I can just have it drop all the
junk I don't want, but this is a very hokey design.

> rmt_storage &

This is still a proprietary component. Fortunately this is a working
replacement:

https://github.com/andersson/rmtfs

and with that (and creating some zero-filled files at
/boot/modem_fs{1,2,c,g}), things work for me.

Brian

> tqftpserv &
> 
> 
> Thanks,
> Govind
