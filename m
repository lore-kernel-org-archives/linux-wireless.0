Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:56760 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZIXULh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 16:11:37 -0400
Received: by ewy7 with SMTP id 7so2002090ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 13:11:40 -0700 (PDT)
Message-ID: <4ABBD278.3050207@tuffmail.co.uk>
Date: Thu, 24 Sep 2009 21:11:36 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Mattia Dongili <malattia@linux.it>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Norbert Preining <preining@logic.at>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
Subject: Re: [PATCH] sony-laptop: check for rfkill hard block at load time
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at> 	<1253801252.3868.108.camel@johannes.local> <4ABB89B2.8070302@tuffmail.co.uk> 	<1253804713.3868.168.camel@johannes.local> <4ABB8C5E.6070402@tuffmail.co.uk> 	<1253813371.3868.313.camel@johannes.local> <4ABBC54C.5010103@tuffmail.co.uk> <69e28c910909241224q10202a47o37ba0f3975ee3294@mail.gmail.com>
In-Reply-To: <69e28c910909241224q10202a47o37ba0f3975ee3294@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> On Thu, Sep 24, 2009 at 9:15 PM, Alan Jenkins
> <alan-jenkins@tuffmail.co.uk> wrote:
>   
>> "I recently (on a flight) I found out that when I boot with the hard-switch
>> activated, so turning off all wireless activity on my laptop, the state
>> is not correctly announced in /dev/rfkill (reading it with rfkill command,
>> or my own gnome applet)...
>>
>> After turning off and on again the hard-switch the events were right."
>>
>> We can fix this by querying the firmware at load time and calling
>> rfkill_set_hw_state().
>>
>> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>> Tested-by: Norbert Preining <preining@logic.at>
>> ---
>>  drivers/platform/x86/sony-laptop.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
>> index dafaa4a..a234a9d 100644
>> --- a/drivers/platform/x86/sony-laptop.c
>> +++ b/drivers/platform/x86/sony-laptop.c
>> @@ -1081,6 +1081,8 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
>>        struct rfkill *rfk;
>>        enum rfkill_type type;
>>        const char *name;
>> +       int result;
>> +       bool hwblock;
>>
>>        switch (nc_type) {
>>        case SONY_WIFI:
>> @@ -1108,6 +1110,10 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
>>        if (!rfk)
>>                return -ENOMEM;
>>
>> +       sony_call_snc_handle(0x124, 0x200, &result);
>>     
>
> Please define these somewhere, don't use magic numbers.
>   

The rfkill functions are all together in the file, it's not that bad. 
But ok.

There's another bug / missing feature - it doesn't re-read the hard
states on resume from suspend.

I'll submit two more patches then.  I won't convert all of the magic
numbers though.  This isn't hardware I know anything about, and "magic
numbers" is a good description of some of them -

    /* Setup hotkeys */
    sony_call_snc_handle(0x0100, 0, &result);
    sony_call_snc_handle(0x0101, 0, &result);
    sony_call_snc_handle(0x0102, 0x100, &result);
    sony_call_snc_handle(0x0127, 0, &result);

Others are already sufficiently obvious, and the extra indirection would
only serve to obscure

    /* Enable all events */
    acpi_callsetfunc(sony_nc_acpi_handle, "SN02", 0xffff, &result);
