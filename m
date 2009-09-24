Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:56855 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbZIXPGw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 11:06:52 -0400
Received: by fg-out-1718.google.com with SMTP id 22so600286fge.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 08:06:55 -0700 (PDT)
Message-ID: <4ABB89B2.8070302@tuffmail.co.uk>
Date: Thu, 24 Sep 2009 16:01:06 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Norbert Preining <preining@logic.at>,
	linux-wireless@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
Subject: Re: rfkill hard state after booting
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at> <1253801252.3868.108.camel@johannes.local>
In-Reply-To: <1253801252.3868.108.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2009-09-24 at 15:02 +0200, Norbert Preining wrote:
>
>   
>> I recently (on a flight) I found out that when I boot with the hard-switch
>> activated, so turning off all wireless activity on my laptop, the state
>> is not correctly announced in /dev/rfkill (reading it with rfkill command,
>> or my own gnome applet). All the devices seem to be in normal state but
>> one.
>>     
>
> Very strange.
>
>   
>> Here some outputs:
>> $ cd /sys/class/rfkill
>> $ ls
>> rfkill0@  rfkill1@  rfkill2@  rfkill3@	rfkill4@  rfkill5@
>> $ cat rfkill?/name
>> sony-wifi
>> sony-bluetooth
>> sony-wwan
>> hso-0
>> hci0
>> phy0
>> $
>>
>> and the three sony-* are the ones for actually turning on/off the devices,
>> but they showed all soft 0 hard 0 at initial startup. Only phy0 (AFAIR)
>> had hard 1.
>>     
>
> Makes sense. I mean, that phy0 was hard blocked.
>
>   
>> After turning off and on again the hard-switch the events were right.
>>     
>
> I can't decide where this bug is. I suspect it's in the sony code.
> Anyone feel responsible for that code?
>
> johannes
>   

I think it's pretty clear it's in the sony code.  It doesn't call
set_hw_state() during init.  I.e. (completely untested):

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index dafaa4a..a234a9d 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1081,6 +1081,8 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
 	struct rfkill *rfk;
 	enum rfkill_type type;
 	const char *name;
+	int result;
+	bool hwblock;
 
 	switch (nc_type) {
 	case SONY_WIFI:
@@ -1108,6 +1110,10 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
 	if (!rfk)
 		return -ENOMEM;
 
+	sony_call_snc_handle(0x124, 0x200, &result);
+	hwblock = !(result & 0x1);
+	rfkill_set_hw_state(rfk, hwblock);
+
 	err = rfkill_register(rfk);
 	if (err) {
 		rfkill_destroy(rfk);

