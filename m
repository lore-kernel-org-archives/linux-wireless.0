Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:49954 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZIYJNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 05:13:46 -0400
Received: by bwz6 with SMTP id 6so1886210bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 02:13:49 -0700 (PDT)
Message-ID: <4ABC89C5.70609@tuffmail.co.uk>
Date: Fri, 25 Sep 2009 10:13:41 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mattia Dongili <malattia@linux.it>,
	Norbert Preining <preining@logic.at>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] sony-laptop: check for rfkill hard block at load time
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at> <1253801252.3868.108.camel@johannes.local> <4ABB89B2.8070302@tuffmail.co.uk> <1253804713.3868.168.camel@johannes.local> <4ABB8C5E.6070402@tuffmail.co.uk> <1253813371.3868.313.camel@johannes.local> <4ABBC54C.5010103@tuffmail.co.uk> <20090924223805.GA29169@kamineko.org>
In-Reply-To: <20090924223805.GA29169@kamineko.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mattia Dongili wrote:
> On Thu, Sep 24, 2009 at 08:15:24PM +0100, Alan Jenkins wrote:
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
>
> Is it worth trying to get this into a stable release?
>   

Sure.  It seems to fit, and all we have to do is add a CC to the patch

>> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>> Tested-by: Norbert Preining <preining@logic.at>
>>     
>
> Acked-by: Mattia Dongili <malattia@linux.it>
>   

CC: stable@kernel.org

>   
>> ---
>>  drivers/platform/x86/sony-laptop.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
>> index dafaa4a..a234a9d 100644
>> --- a/drivers/platform/x86/sony-laptop.c
>> +++ b/drivers/platform/x86/sony-laptop.c
>> @@ -1081,6 +1081,8 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
>>  	struct rfkill *rfk;
>>  	enum rfkill_type type;
>>  	const char *name;
>> +	int result;
>> +	bool hwblock;
>>  
>>  	switch (nc_type) {
>>  	case SONY_WIFI:
>> @@ -1108,6 +1110,10 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
>>  	if (!rfk)
>>  		return -ENOMEM;
>>  
>> +	sony_call_snc_handle(0x124, 0x200, &result);
>> +	hwblock = !(result & 0x1);
>> +	rfkill_set_hw_state(rfk, hwblock);
>> +
>>  	err = rfkill_register(rfk);
>>  	if (err) {
>>  		rfkill_destroy(rfk);
>> -- 
>> 1.6.3.2
>>
>>
>>
>>     

