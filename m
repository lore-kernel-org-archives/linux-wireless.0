Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40500 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2BMTnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 14:43:18 -0500
MIME-Version: 1.0
In-Reply-To: <4F391470.3090102@gmail.com>
References: <1ec0e63a7453072689618430ebc2bdd7b62542a2.1329073559.git.marvin24@gmx.de>
	<86044d44009316a48b402050f9dd742391d46eac.1329073559.git.marvin24@gmx.de>
	<CAPnjgZ2b4QjKMKjKyHqGGU1TbMamq6pBPUAAO99gMa98Rd+Erw@mail.gmail.com>
	<4F391470.3090102@gmail.com>
Date: Mon, 13 Feb 2012 11:43:17 -0800
Message-ID: <CAOesGMjofzC9pp1H9SXS693QR7JU9XjvVLVi6gBSGuqVNJ-rKA@mail.gmail.com> (sfid-20120213_204329_771986_6FE20CC1)
Subject: Re: [PATCH 2/3] dt: rfkill-gpio: add bindings documentation
From: Olof Johansson <olof@lixom.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Simon Glass <sjg@chromium.org>, Marc Dietrich <marvin24@gmx.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Colin Cross <ccross@android.com>, linux-tegra@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Feb 13, 2012 at 5:47 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 02/12/2012 02:21 PM, Simon Glass wrote:
>> Hi Marc,
>>
>> On Sun, Feb 12, 2012 at 11:13 AM, Marc Dietrich <marvin24@gmx.de> wrote:
>>> Add device tree bindings information for rfkill gpio switches.
>>>
>>> Cc: linux-wireless@vger.kernel.org
>>> Cc: "John W. Linville" <linville@tuxdriver.com>
>>> Cc: Johannes Berg <johannes@sipsolutions.net>
>>> Cc: Rhyland Klein <rklein@nvidia.com>
>>> Cc: Grant Likely <grant.likely@secretlab.ca>
>>> Cc: devicetree-discuss@lists.ozlabs.org
>>> Signed-off-by: Marc Dietrich <marvin24@gmx.de>
>>> ---
>>>  Documentation/devicetree/bindings/gpio/rfkill.txt |   38 +++++++++++++++++++++
>>>  1 files changed, 38 insertions(+), 0 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/gpio/rfkill.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/gpio/rfkill.txt b/Documentation/devicetree/bindings/gpio/rfkill.txt
>>> new file mode 100644
>>> index 0000000..22bf22a
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/gpio/rfkill.txt
>>> @@ -0,0 +1,38 @@
>>> +RFKILL switches connected to GPIO lines
>>> +
>>> +Required properties:
>>> +- compatible : should be "rfkill-gpio".
>>> +
>>> +Each rfkill switch is represented as a sub-node of the rfkill-gpio device.
>>> +Each node has a label property which represents the name of the corresponding
>>> +rfkill device.
>>> +
>>> +RFKILL sub-node properties:
>>> +- label :  (optional) The label for this rfkill switch.  If omitted, the label is
>>> +  taken from the node name (excluding the unit address).
>>> +- reset-gpio, shutdown-gpio :  Should specify the rfkill gpios for reset and
>>> +  shutdown (see "Specifying GPIO information for devices" in
>>
>> Should that be reset-gpios, shutdown-gpios? Even though you have only
>> one it seems that people put an 's' on the end.

Agreed.

>>
>>> +  Documentation/devicetree/booting-without-of.txt).
>>> +- type : enumerated type of the gpio (see include/linux/rfkill.h).
>>
>> It would be better I think if this were explicit here. If you have a
>> number, then what values does it take and what do they mean?

This should most likely be moved to a set of properties instad of an
enumerated type, I agree. And/or use a string to encode the type
simiar to how powerpc does some of the USB interfaces.

>>> +- clock : (optional) name of the clock name associated with the rfkill switch
>>
>> Can this be a phandle instead of a string?
>
> This seems to be in the wrong place altogether. The gpio controller
> would have a clock, not particular gpio line.

And either way, this should conform to the standard clock binding, not
use something locally hacked up.

>>> +  (see include/linux/rfkill-gpio.h)
>>
>> IMO device tree bindings should be fully documented in this file,
>> rather than needing to look at a separate header. This is particularly
>> true if the binding is used in another project.
>>
>
> Correct. A binding should not be Linux specific. It should describe the h/w.
>
>>> +
>>> +Examples:
>>> +
>>> +rfkill-switches {
>>> +       compatible = "rfkill-gpio";
>>> +
>>> +       wifi {
>>> +               label = "wifi";
>>> +               reset-gpio = <&gpio 25 0>; /* Active high */
>>> +               shutdown-gpio = <&gpio 85 0>; /* Active high */
>>> +               type = <1>;
>>> +       };
>>> +
>>> +       bt {
>>> +               label = "bluetooth";
>>> +               reset-gpio = <&gpio 17 0>; /* Active high */
>>> +               shutdown-gpio = <&gpio 35 0>; /* Active high */
>>> +               type = <1>;
>>> +       };
>
> Why wouldn't the gpio lines just be part of the bt and wifi device nodes
> themselves? The DT is supposed to describe h/w connections.

The thing is, that "rfkill" isn't a _device_, and Marc is trying to
describe it as one. It's really just a software abstraction of a
collection of power supplies and/or GPIO lines that are used to power
up/down specific peripherals.

I know that the USB modem, for example, is probed through autoprobing
the USB bus. So there's no device to associate it with, per se. But
the USB slot that the modem is connected to, which is also the
connector that the GPIO controls the power supplies and reset line to,
are connected directly to one of the USB host controllers, right? So
maybe describing it there is a better option.

That still leaves the issue of actually having something to bind it
against. As I already said, rfkill isn't a device, so crafting one
just because linux wants one is the wrong way to go about. Maybe using
/chosen to refer to the device nodes for the GPIO lines under USB
instead, and have rfkill look for those and create a device if they're
found is a better way to go about it.


-Olof
