Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:39782 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2ACMYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 07:24:38 -0500
Date: Tue, 3 Jan 2012 12:24:24 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Jack Stone <jwjstone@fastmail.fm>,
	Oliver Neukum <oliver@neukum.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120103122424.GA24367@srcf.ucam.org> (sfid-20120103_132452_841071_7A1A06C9)
References: <20120102215028.GA15701@srcf.ucam.org>
 <Pine.LNX.4.44L0.1201022136190.20386-100000@netrider.rowland.org>
 <20120103032505.GA19702@srcf.ucam.org>
 <CA+55aFxnOBJZBb5KC7HC3z9Whk585SaHeCx9zyie3MMsfsvExw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CA+55aFxnOBJZBb5KC7HC3z9Whk585SaHeCx9zyie3MMsfsvExw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 02, 2012 at 09:53:46PM -0800, Linus Torvalds wrote:
> On Mon, Jan 2, 2012 at 7:25 PM, Matthew Garrett <mjg@redhat.com> wrote:
> > On Mon, Jan 02, 2012 at 09:45:58PM -0500, Alan Stern wrote:
> >
> >> Wait a second.  Why does isight_firmware bind at this time?  Binding to
> >> new devices is handled by khubd, which doesn't start running again
> >> until after the resume is finished (the device appears to be new
> >> because its descriptors have changed).  At that point there should be
> >> no trouble reloading the firmware.
> >
> > Then why are we getting this warning? The firmware is only loaded in the
> > probe function.
> 
> The USB suspend/resume function does that "unbind/rebind" dance, and
> that causes a "device_attach()". Which causes a probe() to be called.
> 
> Should it do that? I think not, not if the ID's haven't changed. But I
> don't know the USB layer all that well.

The IDs will have changed due to the firmware falling out.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
