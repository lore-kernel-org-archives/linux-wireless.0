Return-Path: <SRS0=ngAs=TX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E922CC282DD
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 15:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 728FB206BA
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 15:28:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="0Lf3kAxq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfEWP2h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 May 2019 11:28:37 -0400
Received: from narfation.org ([79.140.41.39]:56526 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730829AbfEWP2h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 May 2019 11:28:37 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2019 11:28:36 EDT
Received: from bentobox.localnet (p200300C5971088F600000000000002FB.dip0.t-ipconnect.de [IPv6:2003:c5:9710:88f6::2fb])
        by v3-1039.vlinux.de (Postfix) with ESMTPSA id 62E611100DE;
        Thu, 23 May 2019 17:22:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1558624951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJx5n8tw3tAbvpIBdOxu5SLNZwU5xrtrDUulAwT3ZTs=;
        b=0Lf3kAxqG2mrmN/ho7MVt6Ylz1biV1KBfex1bEvRnf2XN219id5XkJ0UrFuIhNuudHGMFH
        /UEtDRejV10wbhXVZLHJx+ZVUWROnl79kifmzzI7ZUAesAJ3d4CndXce289oAjndyXiXSu
        ere1av5M0NGC/urK3y72nQvZGVZ8wQU=
From:   Sven Eckelmann <sven@narfation.org>
To:     John Crispin <john@phrozen.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>
Subject: Re: [PATCH] iw: print HE capabilities
Date:   Thu, 23 May 2019 17:22:28 +0200
Message-ID: <1842558.Gi2HMOcgDq@bentobox>
In-Reply-To: <20190520105416.27185-1-john@phrozen.org>
References: <20190520105416.27185-1-john@phrozen.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4613703.SjJBcg5bSb"; micalg="pgp-sha512"; protocol="application/pgp-signature"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1558624951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJx5n8tw3tAbvpIBdOxu5SLNZwU5xrtrDUulAwT3ZTs=;
        b=sQdwlHHAJxHTC+C8hI7DyeSg3R9Sq4gQjRq6rK6kMW81NucuyJPUgtYBz0zf4IsRuLcxMC
        L7655QK0ClVe7xwKfTPCPC67IZhCCa4DOeAJa/n5EbZ28L359pKdVN5M0mtB1u9whkuOj/
        BO8aagrcp16L3+V5P+aNFlQkT55P8j4=
ARC-Seal: i=1; s=20121; d=narfation.org; t=1558624951; a=rsa-sha256;
        cv=none;
        b=v/RoauH2qamCjRn/elFZMxUG4rGLI2ZLSR0AumcBsmJ4GiZN5kxXqw8AvS7K36RguVmKN1
        RgVjRajZoQURlGhjxbEZPZon3/GwdObNq5YRpI95RPOykQB/o71eBFJkFyudiLCRgb/wph
        tTnf0+CfJ+0jhaztmKZO7mMNSqIcUHs=
ARC-Authentication-Results: i=1;
        v3-1039.vlinux.de;
        auth=pass smtp.auth=sven smtp.mailfrom=sven@narfation.org
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--nextPart4613703.SjJBcg5bSb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, 20 May 2019 12:54:16 CEST John Crispin wrote:
> +       char *iftypes[NUM_NL80211_IFTYPES] = {
> +               "Unspec", "Adhoc", "Station", "AP", "AP/VLAN", "WDS", "Monitor"
> +               "Mesh", "P2P/Client", "P2P/Go", "P2P/Device", "OCB", "NAN",
> +       };

Noticed during tests with hwsim that this list is slightly incorrect - because 
the "," is missing after "Monitor". Thus you will now have an entry 
"MonitorMesh" instead of two entries "Monitor" + "Mesh". So everything after 
NL80211_IFTYPE_MESH_POINT is off by one.

Kind regards,
	Sven
--nextPart4613703.SjJBcg5bSb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlzmurQACgkQXYcKB8Em
e0ZM0BAAvSnONZ1qxM7Z2iOAIDOcXEfUb6uOmH23wn+YPB0/iXM9hVNoNKcOglAW
zdzHM4UQ4B8vbKW0YIgf9QX7jMzzQDAxLCFT8HOX6aA9/cH+5gFJ8X6YuWVRbFZf
KKMSqWyMhLJdAzr4SJQ0Al5KcMs0zDUwDviq7X4DLtvqeZWbHHn1u0BZ4N/6FHuA
26qioIrRCJg+/f1DCbvLqD09yXQCxBxgUXc31nCALRVF/N4/PTiMceAzxRxlhlLK
pVTI86q3mVrAGBRqpCJ52P7Ga0Ay5G39bG0LGw0hXXC6XXVah5AZaR7G06a79G7D
lep/WBfB+nscUu4hgW0h6NXdbz87WpcFLesxgFNC+qsTe0QvLXQS5RoagrQ21H6L
X09KOX7F70MM0qurPGWabdt8o+tmYstB0FdxkxzMDud0mNcs5mZiHWLEmUrHYNlV
A5JGftsVbGvWbmA++opyGsGjQtJla/0tii45g7k/Ua3CqkQ4ppXBOFho5A1KwXga
cfcQ36yacH7IZU93jh+bzbpxRJgPJZIjHyvZi0mewg3xpqtzpk6gBW8Ki6uYVB4r
+tFjnCQI5sE28Eq2ivoY5Z/SyOG8myH5ixKVzaj3ZO8Uav2juRulvmJhy4UCr39U
2GtCGZmHVYZTfQy51aL9eIb0eVNXhs8vU3Kz0GrN0hEEq02dOd8=
=Q0X0
-----END PGP SIGNATURE-----

--nextPart4613703.SjJBcg5bSb--



