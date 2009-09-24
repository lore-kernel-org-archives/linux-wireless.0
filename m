Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:51991
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZIXXEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 19:04:16 -0400
Date: Fri, 25 Sep 2009 08:04:15 +0900
From: Mattia Dongili <malattia@linux.it>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Norbert Preining <preining@logic.at>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
Subject: Re: [PATCH] sony-laptop: check for rfkill hard block at load time
Message-ID: <20090924230415.GB29169@kamineko.org>
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at>
 <1253801252.3868.108.camel@johannes.local>
 <4ABB89B2.8070302@tuffmail.co.uk>
 <1253804713.3868.168.camel@johannes.local>
 <4ABB8C5E.6070402@tuffmail.co.uk>
 <1253813371.3868.313.camel@johannes.local>
 <4ABBC54C.5010103@tuffmail.co.uk>
 <69e28c910909241224q10202a47o37ba0f3975ee3294@mail.gmail.com>
 <4ABBD278.3050207@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4ABBD278.3050207@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 09:11:36PM +0100, Alan Jenkins wrote:
> Gábor Stefanik wrote:
> > On Thu, Sep 24, 2009 at 9:15 PM, Alan Jenkins
> > <alan-jenkins@tuffmail.co.uk> wrote:
> >   
...
> >> @@ -1108,6 +1110,10 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
> >>        if (!rfk)
> >>                return -ENOMEM;
> >>
> >> +       sony_call_snc_handle(0x124, 0x200, &result);
> >>     
> >
> > Please define these somewhere, don't use magic numbers.
> >   
> 
> The rfkill functions are all together in the file, it's not that bad. 
> But ok.
> 
> There's another bug / missing feature - it doesn't re-read the hard
> states on resume from suspend.
> 
> I'll submit two more patches then.  I won't convert all of the magic
> numbers though.  This isn't hardware I know anything about, and "magic
> numbers" is a good description of some of them -

right and the whole purpose of them is to hit specific code paths
in the DSDT tables. Not sure we would benefit that much from having
names for them.

-- 
mattia
:wq!
