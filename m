Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43865 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753105AbeCMQk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:40:28 -0400
Date: Tue, 13 Mar 2018 16:40:26 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Andres Rodriguez <andresx7@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH] firmware: add a function to load optional firmware v2
Message-ID: <20180313164026.GG4449@wotan.suse.de> (sfid-20180313_174056_485852_D3DA0D54)
References: <20180309221243.15489-2-andresx7@gmail.com>
 <20180309230925.3573-1-andresx7@gmail.com>
 <CAB=NE6VY62KqmhzD=zT8od=PhgPi3rGKKKxKz_zad-ZrYW-97A@mail.gmail.com>
 <87a7vcazf1.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87a7vcazf1.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2018 at 03:16:34PM +0200, Kalle Valo wrote:
> "Luis R. Rodriguez" <mcgrof@kernel.org> writes:
> 
> >> +/**
> >> + * request_firmware_optional: - request for an optional fw module
> >> + * @firmware_p: pointer to firmware image
> >> + * @name: name of firmware file
> >> + * @device: device for which firmware is being loaded
> >> + *
> >> + * This function is similar in behaviour to request_firmware(), except
> >> + * it doesn't produce warning messages when the file is not found.
> >> + **/
> >> +int
> >> +request_firmware_optional(const struct firmware **firmware_p, const char *name,
> >> +                         struct device *device)
> >> +{
> >> +       int ret;
> >> +
> >> +       /* Need to pin this module until return */
> >> +       __module_get(THIS_MODULE);
> >> +               ret = _request_firmware(firmware_p, name, device, NULL, 0,
> >> +                               FW_OPT_UEVENT | FW_OPT_NO_WARN );
> >> +       module_put(THIS_MODULE);
> >> +       return ret;
> >> +}
> >> +EXPORT_SYMBOL(request_firmware_optional);
> >
> > New exported symbols for the firmware API should be EXPORT_SYMBOL_GPL().
> 
> To me the word optional feels weird to me. For example, in ath10k I
> suspect we would be only calling request_firmware_optional() with all
> firmware and not request_firmware() at all.
> 
> How about request_firmware_nowarn()? That would even match the
> documentation above.

_nowarn() works with me. Do you at least want the return value to give
an error value if no file was found? This way the driver can decide
when to issue an error if it wants to.

  Luis
