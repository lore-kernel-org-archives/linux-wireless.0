Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57199 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549Ab2LYXoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2012 18:44:30 -0500
Message-ID: <1356479032.21837.107.camel@deadeye.wl.decadent.org.uk> (sfid-20121226_004443_606508_313BE633)
Subject: Re: [RFC/RFT] rtk_btusb: Bluetooth driver for Realtek RTL8723AE
 combo device
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Champion Chen <champion_chen@realsil.com.cn>
Date: Tue, 25 Dec 2012 23:43:52 +0000
In-Reply-To: <1356058371-17152-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1356058371-17152-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+7ffNc0H8GupI7FypMP4"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+7ffNc0H8GupI7FypMP4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-12-21 at 02:52 +0000, Larry Finger wrote:
[...]
> --- /dev/null
> +++ b/drivers/bluetooth/rtk_btusb.c
[...]
> +#include <linux/version.h>

Not needed.

> +#include <linux/pm_runtime.h>

Move this up to the first group of #includes.

> +#define HDEV_BUS		(hdev->bus)

This is just obfuscation.

> +#define USB_RPM			1
> +
> +#define GET_DRV_DATA(x)		hci_get_drvdata(x)
> +
> +
> +#define BTUSB_RPM		0	/*1 SS enable; 0 SS disable */

Run-time power management should be enabled if it works and not included
yet if it doesn't.  This shouldn't be a compile-time option in a
production driver.

> +#define LOAD_CONFIG		0

Seems to be a rather pointless development option, but if it still has
some value then it deserves a comment.

> +#define URB_CANCELING_DELAY_MS	10   /*  Added by Realtek */

/* BWH 2012-12-25: Doesn't Realtek have version control to record this? */

[...]
> +/*******************************
> +**    Reasil patch code
> +********************************/

Another weird little bit of history which no-one cares about.

> +#include <linux/firmware.h>
> +#include <linux/suspend.h>
> +#include <net/bluetooth/hci.h>

Belong at the top of the file.

[...]
> +static int rtkbt_pm_notify(struct notifier_block *notifier, ulong pm_eve=
nt,
> +                   void *unused)
> +{
> +       struct dev_data *dev_entry;
> +       struct patch_info       *patch_entry;
> +       struct usb_device *udev;
> +
> +       dev_entry =3D container_of(notifier, struct dev_data, pm_notifier=
);
> +       patch_entry =3D dev_entry->patch_entry;
> +       udev =3D dev_entry->udev;
> +       RTKBT_DBG("rtkbt_pm_notify pm_event =3D%ld", pm_event);
> +       switch (pm_event) {
> +       case PM_SUSPEND_PREPARE:
> +       case PM_HIBERNATION_PREPARE:
> +               patch_entry->fw_len =3D load_firmware(dev_entry,
> +                                                   &patch_entry->fw_cach=
e);

But this is done once for each device, not for each device type.  So you
potentially load the firmware multiple times here and leak all but one.

Anyway I'm not sure this caching is needed any more due to the firmware
management improvements in 3.7.

[...]
> +static int load_firmware(struct dev_data *dev_entry, uint8_t **buff)
> +{
> +#if LOAD_CONFIG
> +	const struct firmware *fw;
> +#endif
> +	struct usb_device *udev;
> +	struct patch_info *patch_entry;
> +	char *fw_name;
> +	int fw_len =3D 0, ret_val;
> +
> +	udev =3D dev_entry->udev;
> +	init_completion(&dev_entry->firmware_loading_complete);
> +	patch_entry =3D dev_entry->patch_entry;
> +	fw_name =3D patch_entry->patch_name;
> +	RTKBT_DBG("Reading firmware file %s", fw_name);
> +	ret_val =3D request_firmware_nowait(THIS_MODULE, 1, fw_name, &udev->dev=
,
> +					  GFP_KERNEL, dev_entry, bt_fw_cb);
> +	if (ret_val < 0)
> +		goto fw_fail;
> +
> +	wait_for_completion(&dev_entry->firmware_loading_complete);

What was the point of using request_firmware_nowait() then?

> +	if (!dev_entry->fw)
> +		goto fw_fail;
> +	*buff =3D kzalloc(dev_entry->fw->size, GFP_KERNEL);
> +	if (NULL =3D=3D *buff)
> +		goto alloc_fail;
> +	memcpy(*buff, dev_entry->fw->data, dev_entry->fw->size);
> +	fw_len =3D dev_entry->fw->size;
> +
> +#if LOAD_CONFIG
> +	release_firmware(dev_entry->fw);
> +	fw_name =3D patch_entry->config_name;
> +	ret_val =3D request_firmware(&fw, fw_name, &udev->dev);
> +	if (ret_val < 0) {
> +		fw_len =3D 0;
> +		kfree(*buff);
> +		*buff =3D NULL;
> +		goto fw_fail;
> +	}
> +
> +	*buff =3D krealloc(*buff, fw_len + fw->size, GFP_KERNEL);
> +	if (NULL =3D=3D *buff) {
> +		fw_len =3D 0;
> +		release_firmware(fw);
> +		goto fw_fail;
> +	}
> +	memcpy(*buff + fw_len, fw->data, fw->size);
> +	fw_len +=3D fw->size;
> +#endif

It's easy to concatenate files in userland; why do it in the driver?

> +alloc_fail:
> +	release_firmware(dev_entry->fw);
> +fw_fail:
> +	return fw_len;
> +}
[...]

--=20
Ben Hutchings
Every program is either trivial or else contains at least one bug

--=-+7ffNc0H8GupI7FypMP4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUNo6OOe/yOyVhhEJAQoWXA/9E4eTezgcn3EbDHSjuMOmm0Xm0l6mkXWF
M4cTb8+qVzGb+agBuugISXMoCwOARWwANFX9vsvPeznICA5vl0aIAdqE2OrQ2sp8
aXihsuBTTk5bp/Z0n/wKjYyOFnr+NiZQFYiSfXdnbOz72gSKPwshjBS3DRCyGkok
YGcLQ7A18Timf0TjjG6lga1ir5XK8iorzoMutM9BzVc6uloCiP1un0F3DqKMHTQ3
MkUNNYvJZnaYiZ2e5GfJBA1NmkPEVkl1ZU3At/lOdRfyihoiHEmrNXpeGmtd98DP
CGOkLb3w0YlNSe4oQPoapP/v8dQNOaN6p8pDVX40mIq/C9yU8rJ8hkXrVV1EbMt/
s/hJfjxzPnmVWfJbUB7IhtsF4NetpJO+27yyShj6oMqw768qlo9gpALXGThDPiI7
CVaIHBhhe6NfDWT7I7KsMjZTH9+ietVAp04hWvh55FtPs/kBr9I9ebg+YGWPxqlq
RNdTjreOeqCq99qwpSjVYtFXrwe/dhWRcMrPwkWElhwGXgJcdYDpaSVkLL8Jh58H
+g726d68K8ExKm3TvQZIiD2OL0T3WMsAS1JSU/8Mxt8GtmMais2pmMnGO9eFgrCL
LYvcGQAqlihM632hqdJVDWVrYxAK0A2SNGLhRBMDHjNNHSwS8baTXKJdQbi9tDeM
NPdkWhdj8ls=
=2fH6
-----END PGP SIGNATURE-----

--=-+7ffNc0H8GupI7FypMP4--
