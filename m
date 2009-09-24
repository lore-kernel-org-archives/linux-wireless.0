Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:15162 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbZIXTYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 15:24:43 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1963732fge.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 12:24:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ABBC54C.5010103@tuffmail.co.uk>
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at>
	<1253801252.3868.108.camel@johannes.local> <4ABB89B2.8070302@tuffmail.co.uk>
	<1253804713.3868.168.camel@johannes.local> <4ABB8C5E.6070402@tuffmail.co.uk>
	<1253813371.3868.313.camel@johannes.local> <4ABBC54C.5010103@tuffmail.co.uk>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 24 Sep 2009 21:24:26 +0200
Message-ID: <69e28c910909241224q10202a47o37ba0f3975ee3294@mail.gmail.com>
Subject: Re: [PATCH] sony-laptop: check for rfkill hard block at load time
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Mattia Dongili <malattia@linux.it>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Norbert Preining <preining@logic.at>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 9:15 PM, Alan Jenkins
<alan-jenkins@tuffmail.co.uk> wrote:
> "I recently (on a flight) I found out that when I boot with the hard-switch
> activated, so turning off all wireless activity on my laptop, the state
> is not correctly announced in /dev/rfkill (reading it with rfkill command,
> or my own gnome applet)...
>
> After turning off and on again the hard-switch the events were right."
>
> We can fix this by querying the firmware at load time and calling
> rfkill_set_hw_state().
>
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Tested-by: Norbert Preining <preining@logic.at>
> ---
>  drivers/platform/x86/sony-laptop.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
> index dafaa4a..a234a9d 100644
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -1081,6 +1081,8 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
>        struct rfkill *rfk;
>        enum rfkill_type type;
>        const char *name;
> +       int result;
> +       bool hwblock;
>
>        switch (nc_type) {
>        case SONY_WIFI:
> @@ -1108,6 +1110,10 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
>        if (!rfk)
>                return -ENOMEM;
>
> +       sony_call_snc_handle(0x124, 0x200, &result);

Please define these somewhere, don't use magic numbers.

> +       hwblock = !(result & 0x1);
> +       rfkill_set_hw_state(rfk, hwblock);
> +
>        err = rfkill_register(rfk);
>        if (err) {
>                rfkill_destroy(rfk);
> --
> 1.6.3.2
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
