Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZBOLKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 06:10:18 -0500
Subject: Re: [PATCH 09/10] cfg80211: move regulatory hints to workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234589627-16977-10-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-10-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-88xE7C+fvvEexK320PU6"
Date: Sun, 15 Feb 2009 12:10:12 +0100
Message-Id: <1234696212.4219.60.camel@johannes.local> (sfid-20090215_121024_119822_F3339BC5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-88xE7C+fvvEexK320PU6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:

> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -396,6 +396,7 @@ enum environment_cap {
>   * 	country IE
>   * @country_ie_env: lets us know if the AP is telling us we are outdoor,
>   * 	indoor, or if it doesn't matter
> + * @list: used to insert into a linked list

I wouldn't mind it explaining which list ;)

> +static LIST_HEAD(reg_requests_list);
> +static DEFINE_MUTEX(reg_mutex);
> +
> +static void reg_process_pending_hints(void);

can you reorder the code in a way that doesn't require forward
declarations?

> +/* This currently only processes user and driver regulatory hints */
> +static int reg_process_hint(struct regulatory_request *reg_request)
> +{

why bother offloading _user_ hints to a workqueue? That seems a little
pointless since we can sleep there and do whatever. OTOH, maybe _all_
should be offloaded so the order is correct?

> +static void reg_process_pending_hints(void)
> +	{
> +	struct regulatory_request *reg_request, *tmp;
> +	int r;
> +
> +	mutex_lock(&reg_mutex);
> +	list_for_each_entry_safe(reg_request, tmp, &reg_requests_list, list) {
> +		r =3D reg_process_hint(reg_request);
> +		if (r)
> +			printk(KERN_ERR "cfg80211: wiphy_idx %d sent a "
> +				"regulatory hint but now has gone fishing, "
> +				"ignoring request\n", reg_request->wiphy_idx);

pointless warning, it'll happen if somebody just inserts/unplugs very
quickly on a loaded system.

> +		list_del(&reg_request->list);
> +		kfree(reg_request);
> +	}
> +	mutex_unlock(&reg_mutex);
> +}

Are you sure the mutex order reg_mutex --> cfg80211_mutex is a good
idea? Is there a need for two locks at all?

johannes

--=-88xE7C+fvvEexK320PU6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJl/gSAAoJEKVg1VMiehFYpCsP/RIh+gPxPMPJycBgAxJN6owi
a9ELNzjY/nfLZgmV/wt78Mr+bNsd7iEIiRPmP9oHNmgmNmy7iybVP6JDptJTEq+K
WArDWbyxKQFJwnvMNCOOAj/GCpOjSnwHKd81EihLIDW0JS6C6RYNofLEc8nT01KW
PTrA8oGxFCgNAxDTyvgSeb78nGx0ywgtSt0YHCst5a72VH78PraW/9Oz/zWLZnwv
qAwWJYuzrT3+1YFXUgrkckBrq7AgfG3RWHu7l3HSQgi8PX63iioRxT8FLQ5U17oK
c8NZm2tCMexjfJHbZAkAxuGbuWQ1CgI6vLKQpoC/bB0CVUHpaJsJcL3TcxcpuiCI
muL6q9uQB5fxCe6PZlaHCf8KzJVmBMNiu+UNJxSPrka8RsA2IWls8iuaNRJk8jl2
5MIvoR9fbD7fIcHOlBbbR9D+1wnuewhE36Cl/2TCHN/7xdKLN3xJPOhtQI9zbmuf
9boFUff7yjGQcBg5woPOG8hC1Q5jihmsQbVSSZyVfRdcRAE6sjIg5cboUDlWEIC2
/sNt2uKSxxhfRxKkqunPP5EJSmb3wQ89BVywiFmb9TCLRo4wm8Len8lsT9B3OouE
AzZNdnzRps0suH+FlMJ264J2iCAI4VE69ECBirjgzGiA546owSipNoV3xrFWGWV1
9PfCY/zA5H8YK97kWqeo
=RwkI
-----END PGP SIGNATURE-----

--=-88xE7C+fvvEexK320PU6--

