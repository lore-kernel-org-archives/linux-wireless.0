Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n19.bullet.mail.mud.yahoo.com ([68.142.206.146]:27531 "HELO
	n19.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751605AbYK3Qxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2008 11:53:37 -0500
Date: Sun, 30 Nov 2008 08:53:36 -0800 (PST)
From: Irwan Siajadi <dev.bahamot@yahoo.com>
Subject: Re: ath5k: can't browse at all.
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227643358.4162.4.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <892922.93252.qm@web59609.mail.ac4.yahoo.com> (sfid-20081130_175343_242979_AD2C6423)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 11/25/08, Pavel Roskin <proski@gnu.org> wrote:

> From: Pavel Roskin <proski@gnu.org>
> Subject: Re: ath5k: can't browse at all.
> To: "Irwan Siajadi" <dev.bahamot@yahoo.com>
> Cc: linux-wireless@vger.kernel.org
> Date: Tuesday, November 25, 2008, 8:02 PM
> On Tue, 2008-11-25 at 09:24 -0800, Irwan Siajadi wrote:
> 
> > Further testing shows that if I change from WPA2/AES
> to WPA/TIKIP, I
> > can finally browse. But it's still hit and missed,
> I need to reload
> > the pages once or twice before the pages can load
> properly. 
> 
> Try disabling hardware crypto in the driver:
> 
> rmmod ath5k
> modprobe ath5k nohwcrypt=1

Sorry for the late reply, being busy with other stuffs.
Anyway, disabling hardware cyrpto didn't make any changes. 

> 
> In any case, check messages from wpa_supplicant.  Maybe
> it's
> reauthenticating very often.  If you flood ping the router
> ("ping -f"),
> you would probably see growing dots that represent lost
> packets.

Flood ping the router doesn't have any lost packets (although only for a 
minute or so). And my router's log shows that the laptop didn't 
re-authenticate very often.

I've also compiled vanilla 2.6.26 and 2.6.27 with ath5k (compat-wireless). 

- 2.6.26.8 + ath5k (compat-wireless-old-2008-11-29, files last editted on
2008-09-16):
-> ping shows some packets loss.
-> can browse any websites.

- 2.6.27.7 + ath5k (compat-wireless-2008-11-26):
-> ping doesn't have any packet loss.
-> can't browse, browser always waiting for the response from the server.
Monitoring the traffics shows that there are tx packets, but there's no rx 
packets.

Anything else I can try?

> 
> -- 
> Regards,
> Pavel Roskin

Thanks,
Irwan.


      

