Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:47935 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab0GHImW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 04:42:22 -0400
Subject: RE: wl1271 firmware
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext Levi, Shahar" <shahar_levi@ti.com>
Cc: Pazzo Da Legare <pazzodalegare@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE66001067C0669@dnce02.ent.ti.com>
References: <AANLkTinOcy-n6EVzAasAJO1I2yNeWOiaCid0tGdxnuwa@mail.gmail.com>
	 <AC090B9732AB2B4DB7FF476E907FE660010673660C@dnce02.ent.ti.com>
	 <AANLkTimcFgxOmw4oOa28unhmSpTt0jNacFKXRXycKKA9@mail.gmail.com>
	 <AANLkTikWzx5SZUxZ9qg5Y9jY44YzZlDvs1kSwbFET76H@mail.gmail.com>
	 <AC090B9732AB2B4DB7FF476E907FE66001067C0669@dnce02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 11:42:05 +0300
Message-ID: <1278578525.8576.19.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On Tue, 2010-07-06 at 14:28 +0200, ext Levi, Shahar wrote:
> > I start from tiwlan.ini file for tiwlan driver to produce an nvs file.
> > Could you please indicate values to use for the following parameters
> > of struct wl1271_nvs_file: general_params.srf1[],
> > general_params.srf2[], general_params.srf3[],
> > dyn_radio_params_2[].params.degraded_low_to_normal_thr,
> > dyn_radio_params_2[].params.normal_to_degraded_high_thr,
> > dyn_radio_params_5[i].params.degraded_low_to_normal_thr,
> > dyn_radio_params_5[i].params.normal_to_degraded_high_thr
> 
> Hi,
> The tiwlan driver ini&NVS files has a different stature then the mac80211 NVS. The parameters you mentioned are RF parameters. 
> I believe it will be the best to get the NVS that mach to the mac80211 (that I am pushing to get).
> Regards,
> Shahar  

You need to get the firmware (wl1271-fw.bin) directly from TI or from
your device manufacturer.  I don't have the permission to redistribute
it.  The latest version that we are using is Rev. 6.1.0.0.310 (you can
check this by running strings on and grepping the binary file).

The NVS file is another story.  It contains device-specific calibration
values and you should probably get those from the device manufacturer.
There is a common part (which is the INI file in tiwlan's terms), which
you need to use to create the binary (check wl1271_ini.h for the binary
file structure).  The more problematic part is the device-specific self
generated calibration.  You need to run a specific sequence of commands
in order to get these values and then apply these values to the correct
place in the binary file.

Shahar, maybe you could contribute a tool to generate the NVS file in
the correct format for wl1271? That would be very cool and would help
lots of people.  Please let me know if you have interest and we can
discuss this in more details.

-- 
Cheers,
Luca.

