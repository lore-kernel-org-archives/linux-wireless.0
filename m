Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938894AbcHJTkU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 15:40:20 -0400
Date: Wed, 10 Aug 2016 21:40:14 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Ming Lei <ming.lei@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Jeff Mahoney <jeffm@suse.com>, Takashi Iwai <tiwai@suse.de>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Vikram Mulukutla <markivx@codeaurora.org>,
	Stephen Boyd <stephen.boyd@linaro.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Tom Gundersen <teg@jklm.no>, Kay Sievers <kay@vrfy.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Josh Boyer <jwboyer@fedoraproject.org>,
	Michal Marek <mmarek@suse.com>,
	David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>, Abhay_Salunke@dell.com,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Jiri Slaby <jslaby@suse.com>, Gilles.Muller@lip6.fr,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Richard Purdie <rpurdie@rpsys.net>, nicolas.palix@imag.fr
Subject: Re: [PATCH v2 8/8] p54: convert to sysdata API
Message-ID: <20160810194014.GO3296@wotan.suse.de> (sfid-20160810_214129_410405_C3C51D7A)
References: <1466121559-22363-1-git-send-email-mcgrof@kernel.org>
 <1466121559-22363-9-git-send-email-mcgrof@kernel.org>
 <CA+55aFyD+Xa2auP05=pBSxQc2qcuR858syMW5fiQKowbqbkDzQ@mail.gmail.com>
 <20160617013657.GH11948@wotan.suse.de>
 <CA+55aFycG-YfukKpP3x7kbBpCzXGwg35SdTU2r4wBbxrfROLtQ@mail.gmail.com>
 <20160617183503.GV11948@wotan.suse.de>
 <20160810183211.GL3296@wotan.suse.de>
 <7451c96a-b4f5-e629-a4a7-76d6fe1772e9@broadcom.com>
 <20160810191708.GO9347@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160810191708.GO9347@sirena.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2016 at 08:17:08PM +0100, Mark Brown wrote:
> On Wed, Aug 10, 2016 at 09:04:38PM +0200, Arend Van Spriel wrote:
> 
> > So why would drivers want the devm solution anyway. Once firmware is
> > loaded in the device it can be freed or do you expect device drivers to
> > keep the firmware/sysdata for suspend/resume scenario as some do because
> > of firmware cache behaviour. Does the "rootfs ready" event cover
> > suspend/resume?
> 
> There are classes of devices that spend a large proportion of their time
> powered off and are only powered up and have firmware loaded when they
> are actively in use.  DSPs used in audio systems are one example of
> this, I'd not be surprised to learn that similar things are done with
> video.  It's too expensive to keep the device powered up and you may be
> swapping between firmwares depending on use case anyway for a lot of
> these devices.

devm use and probe is orthogonal to this use case and suspend/resume.
In any case the proposed new API simply allows the driver caller to
either free the firmware after the consumer callback or to keep it.
It does this without devm, so allows this feature without the API
being used on probe. The point about devm was that it would only
beneficial to us if most users for the API were on probe. Clearly
that's not the case and in fact unless async probe is used that use
is likely buggy as it would delay boot further.

If having a local cache of firmware *beyond* the suspend / resume
case is an optimization that can help we should look into that, but
my preference would be to peg this onto the API through an optional
setting in the request passed.

  Luis
