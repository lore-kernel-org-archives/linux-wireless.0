Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62306 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2BEWA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Feb 2012 17:00:26 -0500
MIME-Version: 1.0
In-Reply-To: <a2291f385edf9692f4a946fd78a7ee7cca29e3b4.1328461986.git.marvin24@gmx.de>
References: <215249735783e9fe35db1c594d901f591725de50.1328461986.git.marvin24@gmx.de>
	<a2291f385edf9692f4a946fd78a7ee7cca29e3b4.1328461986.git.marvin24@gmx.de>
Date: Sun, 5 Feb 2012 14:00:25 -0800
Message-ID: <CAOesGMhXZLRHw+TSVqHZFQcYLeu995EKaG_hNFRkgOnPFdmq6g@mail.gmail.com> (sfid-20120205_230032_262096_C0C31669)
Subject: Re: [PATCH 2/3] dt: rfkill-gpio: add bindings documentation
From: Olof Johansson <olof@lixom.net>
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
	Colin Cross <ccross@android.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Rhyland Klein <rklein@nvidia.com>,
	Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, Feb 5, 2012 at 9:18 AM, Marc Dietrich <marvin24@gmx.de> wrote:
> Add device tree bindings information for rfkill gpio switches.
>
> Cc: linux-wireless@vger.kernel.org
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Rhyland Klein <rklein@nvidia.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Marc Dietrich <marvin24@gmx.de>

Please cc devicetree-discuss@lists.ozlabs.org on device tree bindings;
not everyone monitors the linux mailing lists.



> diff --git a/Documentation/devicetree/bindings/gpio/rfkill.txt b/Documentation/devicetree/bindings/gpio/rfkill.txt
> new file mode 100644
> index 0000000..22bf22a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/rfkill.txt
> @@ -0,0 +1,38 @@
> +RFKILL switches connected to GPIO lines
> +
> +Required properties:
> +- compatible : should be "rfkill-gpio".
> +
> +Each rfkill switch is represented as a sub-node of the rfkill-gpio device.
> +Each node has a label property which represents the name of the corresponding
> +rfkill device.
> +
> +RFKILL sub-node properties:
> +- label :  (optional) The label for this rfkill switch.  If omitted, the label is
> +  taken from the node name (excluding the unit address).
> +- reset-gpio, shutdown-gpio :  Should specify the rfkill gpios for reset and
> +  shutdown (see "Specifying GPIO information for devices" in
> +  Documentation/devicetree/booting-without-of.txt).
> +- type : enumerated type of the gpio (see include/linux/rfkill.h).
> +- clock : (optional) name of the clock name associated with the rfkill switch
> +  (see include/linux/rfkill-gpio.h)

Sorry, but this is going about things the wrong way.

A device tree binding is meant to describe hardware. For example, the
type and clock properties are clearly linux specifics that shouldn't
be expressed that way in the device tree.

instead, think about what you actually need to provide for a driver to
do its work. Does the wifi device have a gpio to control power (and
one for providing reset outside of the standard interface)? Well, then
that should probably be defined in the node that describes the device
-- i.e. under the sdhci node in question here.

That doesn't fit the rfkill device/driver model perfectly, since it
doesn't have something to bind against, so the rfkill platform device
needs to be instantiated from somewhere else. It's possible that best
match is to have the wifi driver handle it, which should be OK, I
think?


-Olof
