Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:63262 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYKTQ1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 11:27:40 -0500
Received: by an-out-0708.google.com with SMTP id d40so239158and.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 08:27:38 -0800 (PST)
Message-ID: <f6ca9fed0811200827y3e07bb6ag8c46e61c44fbc610@mail.gmail.com> (sfid-20081120_172744_055518_ECBA6B7E)
Date: Thu, 20 Nov 2008 17:27:38 +0100
From: drago01 <drago01@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [GIT PATCH] rfkill fixes for 2.6.28-rc3
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org,
	"Matthew Garrett" <mjg59@srcf.ucam.org>,
	"Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
In-Reply-To: <20081112211530.GH2411@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br>
	 <200811031747.16326.IvDoorn@gmail.com>
	 <20081103170243.GB2417@khazad-dum.debian.net>
	 <200811031820.41165.IvDoorn@gmail.com>
	 <20081112211530.GH2411@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 12, 2008 at 10:15 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Nov 03, 2008 at 06:20:40PM +0100, Ivo van Doorn wrote:
>> On Monday 03 November 2008, Henrique de Moraes Holschuh wrote:
>> > On Mon, 03 Nov 2008, Ivo van Doorn wrote:
>> > > On Monday 03 November 2008, Henrique de Moraes Holschuh wrote:
>> > > > This small patchset contains two fixes to issues in the suspend/resume
>> > > > handling of the rfkill class core.
>> > > >
>> > > > It needs to go to 2.6.28.  These patches are based on 2.6.28-rc3.
>> > >
>> > > Are they real regressions or normal bugfixes?
>> >
>> > I am not sure if they regress anything, but I am pretty sure there is no
>> > bugzilla entry about them yet.  I have added two more interested parties to
>> > the CC.
>> >
>> > So, if there is a strong feeling this would best be held until the next
>> > merge window, I can certainly respin the patches to on top of
>> > wireless-testing...
>>
>> Well I'll give my ACK to the 2 patches, but I'll let john decide if they
>> are "regression" enough for 2.6.28. ;)
>
> So I keep looking at these patches, and I'm not sure about them.
> It seems that they restore the rfkill state after resume to what it
> was before the suspend.

Wouldn't this break hw kill switches?
If I move the switch while the system is suspended it will ignore this
event but the hw will still not work.

> What I am unsure about is whether or not
> that is the appropriate thing to do.  I suppose it makes sense under
> the rule of least surprise.

Well the above scenario would be just broken.
Unless the driver rereads the real hw state and updates the rfkill
state on resume.
