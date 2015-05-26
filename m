Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:46034 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255AbbEZTQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:16:10 -0400
Date: Tue, 26 May 2015 22:15:53 +0300
From: Petko Manolov <petkan@mip-labs.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150526191553.GH5526@localhost> (sfid-20150526_211629_123350_E98C1CD6)
References: <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
 <20150520164613.GD10473@localhost>
 <20150521044104.GH22632@kroah.com>
 <20150521054101.GA15037@localhost>
 <20150521061453.GC30864@kroah.com>
 <1432213521.4230.43.camel@linux.vnet.ibm.com>
 <20150521154508.GA11821@kroah.com>
 <20150521155319.GG18164@localhost>
 <20150526180813.0ba1b5f5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150526180813.0ba1b5f5@lxorguk.ukuu.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-05-26 18:08:13, One Thousand Gnomes wrote:
> On Thu, 21 May 2015 18:53:19 +0300
> Petko Manolov <petkan@mip-labs.com> wrote:
> 
> > It is device's job to verify firmware's correctness.  It is user's job to 
> > verify vendor's identity.  Two different things, not related to each other.
> 
> The device verifies the firmwares identity. The firmware's correctness is 
> unknownable if the mathematicians are correct.

Or so the story goes... :)

Anyway, bad choice of words.  I meant to say its device's responsibility to 
verify binary blob's integrity, be it firmware or something else.

> The device will accept firmware signed in some manner with some key that is 
> probably part of a root of trust embedded deeply im the hardware itself. If 
> it's vendor X hardware then firmware not signed with the key for that hardware 
> won't work, and vendor X has the key locked away.

Ideally, this would be the case.  However, as far as i know there is very few 
devices out there that will do what you describe.  First, it is complex.  
Second, and more important, it is expensive.  Third, if the root of trust is 
compromised the device is done for.  Or rather its user.

Considering the above i guess this isn't going to happen anytime soon, except 
for highly specialized devices.  Of course i may not be correct.  In 
mathematical sense as well. :)

> It's also worth remembering most of the dumb non signature checking devices 
> are things like USB. They don't have access to the internals of the system so 
> their attack options are more limited.

Most devices just lack the infrastructure.  Especially those that are used in 
the embedded world.  Very few of them are designed to withstand relatively 
moderate attempt on their security.  Speaking about hardware.  Come the software, 
things are quickly getting messier.


> On Thu, 21 May 2015 16:03:02 +0000
> "Woodhouse, David" <david.woodhouse@intel.com> wrote:
> 
> > In the case where kernel and modules are signed, it *is* useful for a kernel 
> > device driver also to be able to validate that what it's about to load into 
> > a device is authentic.
> 
> You also need to know its "authentic" for that specific device. Otherwise you 
> may be able to exploit something by loading an authentic firmware for another 
> piece of hardware.

Well, yes this may easily happen.  Integrity checks aren't going to help here.

> Ie you need to sign something more than the firmware, such as (firmware, 
> modinfo), so it's signed for "firmware X on PCI:8086,1114 or "firmware Y on 
> ACPI:0A1D"

Should work as long as the HW IDs can't be tampered with.

> I want to understand the model, who signs what, and what security is allegedly 
> provided over the existing. If there are users sufficiently paranoid to 
> believe that signing firmware saves them, then fine. For most hardware it can 
> cut out some attackers, although anyone with sufficient money or a TLA can no 
> doubt just tap someone on the shoulder and say you are signing this for us.

That's always the case with security, root/chain of trust, etc.  There's always 
someone with bigger gun.  Most systems that aren't compromised are those that do 
not draw attention, mostly because of their insignificance.

> IMHO we want the supplier of a given firmware providing signatures on the 
> firmware git tree if this is done. A generic linux-firmware owned key would be 
> both a horrendously inviting attack target, and a single point of failure.
>
> Git can already do all the needed commit signing bits unless I'm missing 
> something here ?

If i read the above correctly you propose to have a tree where all binary blobs 
(or whatever data) will be trusted, because their authenticity will be verified 
prior to their inclusion?  By cloning this tree i should also trust its content 
because GIT takes care of data's integrity?


		Petko
