Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:33376 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYKTQyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 11:54:55 -0500
Received: by yw-out-2324.google.com with SMTP id 9so247291ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 08:54:54 -0800 (PST)
Message-ID: <f6ca9fed0811200854l52e03b22t9b2f247571a524a0@mail.gmail.com> (sfid-20081120_175459_505583_4CE2A298)
Date: Thu, 20 Nov 2008 17:54:53 +0100
From: drago01 <drago01@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [GIT PATCH] rfkill fixes for 2.6.28-rc3
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org,
	"Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
In-Reply-To: <20081120163124.GA10899@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br>
	 <200811031747.16326.IvDoorn@gmail.com>
	 <20081103170243.GB2417@khazad-dum.debian.net>
	 <200811031820.41165.IvDoorn@gmail.com>
	 <20081112211530.GH2411@tuxdriver.com>
	 <f6ca9fed0811200827y3e07bb6ag8c46e61c44fbc610@mail.gmail.com>
	 <20081120163124.GA10899@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2008 at 5:31 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Nov 20, 2008 at 05:27:38PM +0100, drago01 wrote:
>> On Wed, Nov 12, 2008 at 10:15 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > So I keep looking at these patches, and I'm not sure about them.
>> > It seems that they restore the rfkill state after resume to what it
>> > was before the suspend.
>>
>> Wouldn't this break hw kill switches?
>> If I move the switch while the system is suspended it will ignore this
>> event but the hw will still not work.
>
> Whichever driver is responsible for listening to the hardware events
> should handle that in its own resume method. The rfkill state
> restoration code will only be relevant for restoring state set by
> sofware.
>
>> Well the above scenario would be just broken.
>> Unless the driver rereads the real hw state and updates the rfkill
>> state on resume.
>
> Quite. How else are you going to know if a switch has moved in the
> intervening time?

Yeah that makes sense, please ignore my comment ;)
