Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55582 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751438AbeEJX0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 19:26:43 -0400
Date: Thu, 10 May 2018 23:26:39 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Jones <pjones@redhat.com>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-integrity@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Rodriguez <andresx7@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/6] firmware: differentiate between signed regulatory.db
 and other firmware
Message-ID: <20180510232639.GF27853@wotan.suse.de> (sfid-20180511_012657_751708_65692A59)
References: <20180504000743.GR27853@wotan.suse.de>
 <1525393466.3539.133.camel@linux.vnet.ibm.com>
 <20180508173404.GG27853@wotan.suse.de>
 <1525865428.3551.175.camel@linux.vnet.ibm.com>
 <20180509191508.GR27853@wotan.suse.de>
 <1525895838.3551.247.camel@linux.vnet.ibm.com>
 <20180509212212.GX27853@wotan.suse.de>
 <1525903617.3551.281.camel@linux.vnet.ibm.com>
 <20180509234814.GY27853@wotan.suse.de>
 <1525917658.3551.322.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1525917658.3551.322.camel@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 09, 2018 at 10:00:58PM -0400, Mimi Zohar wrote:
> On Wed, 2018-05-09 at 23:48 +0000, Luis R. Rodriguez wrote:
> > On Wed, May 09, 2018 at 06:06:57PM -0400, Mimi Zohar wrote:
> 
> > > > > Yes, writing regdb as a micro/mini LSM sounds reasonable.  The LSM
> > > > > would differentiate between other firmware and the regulatory.db based
> > > > > on the firmware's pathname.
> > > > 
> > > > If that is the only way then it would be silly to do the mini LSM as all
> > > > calls would have to have the check. A special LSM hook for just the
> > > > regulatory db also doesn't make much sense.
> > > 
> > > All calls to request_firmware() are already going through this LSM
> > > hook.  I should have said, it would be based on both READING_FIRMWARE
> > > and the firmware's pathname.
> > 
> > Yes, but it would still be a strcmp() computation added for all
> > READING_FIRMWARE. In that sense, the current arrangement is only open coding the
> > signature verification for the regulatory.db file.  One way to avoid this would
> > be to add an LSM specific to the regulatory db
> 
> Casey already commented on this suggestion.

Sorry but I must have missed this, can you send me the email or URL where he did that?
I never got a copy of that email I think.

  Luis
