Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:51168
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZIXWt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 18:49:29 -0400
Date: Fri, 25 Sep 2009 07:38:06 +0900
From: Mattia Dongili <malattia@linux.it>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Norbert Preining <preining@logic.at>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
Subject: Re: [PATCH] sony-laptop: check for rfkill hard block at load time
Message-ID: <20090924223805.GA29169@kamineko.org>
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at>
 <1253801252.3868.108.camel@johannes.local>
 <4ABB89B2.8070302@tuffmail.co.uk>
 <1253804713.3868.168.camel@johannes.local>
 <4ABB8C5E.6070402@tuffmail.co.uk>
 <1253813371.3868.313.camel@johannes.local>
 <4ABBC54C.5010103@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4ABBC54C.5010103@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 08:15:24PM +0100, Alan Jenkins wrote:
> "I recently (on a flight) I found out that when I boot with the hard-switch
> activated, so turning off all wireless activity on my laptop, the state
> is not correctly announced in /dev/rfkill (reading it with rfkill command,
> or my own gnome applet)...
> 
> After turning off and on again the hard-switch the events were right."
> 
> We can fix this by querying the firmware at load time and calling
> rfkill_set_hw_state().

Is it worth trying to get this into a stable release?

> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Tested-by: Norbert Preining <preining@logic.at>

Acked-by: Mattia Dongili <malattia@linux.it>

> ---
>  drivers/platform/x86/sony-laptop.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
> index dafaa4a..a234a9d 100644
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -1081,6 +1081,8 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
>  	struct rfkill *rfk;
>  	enum rfkill_type type;
>  	const char *name;
> +	int result;
> +	bool hwblock;
>  
>  	switch (nc_type) {
>  	case SONY_WIFI:
> @@ -1108,6 +1110,10 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
>  	if (!rfk)
>  		return -ENOMEM;
>  
> +	sony_call_snc_handle(0x124, 0x200, &result);
> +	hwblock = !(result & 0x1);
> +	rfkill_set_hw_state(rfk, hwblock);
> +
>  	err = rfkill_register(rfk);
>  	if (err) {
>  		rfkill_destroy(rfk);
> -- 
> 1.6.3.2
> 
> 
> 
-- 
mattia
:wq!
