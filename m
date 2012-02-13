Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:33172 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab2BMNrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 08:47:43 -0500
Message-ID: <4F391470.3090102@gmail.com> (sfid-20120213_144747_618920_09157137)
Date: Mon, 13 Feb 2012 07:47:28 -0600
From: Rob Herring <robherring2@gmail.com>
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: Marc Dietrich <marvin24@gmx.de>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Colin Cross <ccross@android.com>, linux-tegra@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/3] dt: rfkill-gpio: add bindings documentation
References: <1ec0e63a7453072689618430ebc2bdd7b62542a2.1329073559.git.marvin24@gmx.de> <86044d44009316a48b402050f9dd742391d46eac.1329073559.git.marvin24@gmx.de> <CAPnjgZ2b4QjKMKjKyHqGGU1TbMamq6pBPUAAO99gMa98Rd+Erw@mail.gmail.com>
In-Reply-To: <CAPnjgZ2b4QjKMKjKyHqGGU1TbMamq6pBPUAAO99gMa98Rd+Erw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2012 02:21 PM, Simon Glass wrote:
> Hi Marc,
> 
> On Sun, Feb 12, 2012 at 11:13 AM, Marc Dietrich <marvin24@gmx.de> wrote:
>> Add device tree bindings information for rfkill gpio switches.
>>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: "John W. Linville" <linville@tuxdriver.com>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Cc: Rhyland Klein <rklein@nvidia.com>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Signed-off-by: Marc Dietrich <marvin24@gmx.de>
>> ---
>>  Documentation/devicetree/bindings/gpio/rfkill.txt |   38 +++++++++++++++++++++
>>  1 files changed, 38 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/gpio/rfkill.txt
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/rfkill.txt b/Documentation/devicetree/bindings/gpio/rfkill.txt
>> new file mode 100644
>> index 0000000..22bf22a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/rfkill.txt
>> @@ -0,0 +1,38 @@
>> +RFKILL switches connected to GPIO lines
>> +
>> +Required properties:
>> +- compatible : should be "rfkill-gpio".
>> +
>> +Each rfkill switch is represented as a sub-node of the rfkill-gpio device.
>> +Each node has a label property which represents the name of the corresponding
>> +rfkill device.
>> +
>> +RFKILL sub-node properties:
>> +- label :  (optional) The label for this rfkill switch.  If omitted, the label is
>> +  taken from the node name (excluding the unit address).
>> +- reset-gpio, shutdown-gpio :  Should specify the rfkill gpios for reset and
>> +  shutdown (see "Specifying GPIO information for devices" in
> 
> Should that be reset-gpios, shutdown-gpios? Even though you have only
> one it seems that people put an 's' on the end.
> 
>> +  Documentation/devicetree/booting-without-of.txt).
>> +- type : enumerated type of the gpio (see include/linux/rfkill.h).
> 
> It would be better I think if this were explicit here. If you have a
> number, then what values does it take and what do they mean?
> 
>> +- clock : (optional) name of the clock name associated with the rfkill switch
> 
> Can this be a phandle instead of a string?
> 

This seems to be in the wrong place altogether. The gpio controller
would have a clock, not particular gpio line.

>> +  (see include/linux/rfkill-gpio.h)
> 
> IMO device tree bindings should be fully documented in this file,
> rather than needing to look at a separate header. This is particularly
> true if the binding is used in another project.
> 

Correct. A binding should not be Linux specific. It should describe the h/w.

>> +
>> +Examples:
>> +
>> +rfkill-switches {
>> +       compatible = "rfkill-gpio";
>> +
>> +       wifi {
>> +               label = "wifi";
>> +               reset-gpio = <&gpio 25 0>; /* Active high */
>> +               shutdown-gpio = <&gpio 85 0>; /* Active high */
>> +               type = <1>;
>> +       };
>> +
>> +       bt {
>> +               label = "bluetooth";
>> +               reset-gpio = <&gpio 17 0>; /* Active high */
>> +               shutdown-gpio = <&gpio 35 0>; /* Active high */
>> +               type = <1>;
>> +       };

Why wouldn't the gpio lines just be part of the bt and wifi device nodes
themselves? The DT is supposed to describe h/w connections.

Rob

>> +};
>> --
>> 1.7.5.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Regards,
> Simon
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss

