Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:39172 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZCYQps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 12:45:48 -0400
Received: by wf-out-1314.google.com with SMTP id 29so123608wff.4
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 09:45:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20090325T082553-834@post.gmane.org>
References: <1237944068-3682-1-git-send-email-lrodriguez@atheros.com>
	<1237944068-3682-2-git-send-email-lrodriguez@atheros.com>
	<loom.20090325T082553-834@post.gmane.org>
Date: Wed, 25 Mar 2009 09:45:32 -0700
Message-ID: <43e72e890903250945pc8a924atc53ede4f698f86da@mail.gmail.com> (sfid-20090325_174552_462655_799C847D)
Subject: Re: [PATCH] cfg80211: fix NULL pointer deference in
	reg_device_remove()
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Quentin Armitage <Quentin@armitage.org.uk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 1:32 AM, Quentin Armitage
<Quentin@armitage.org.uk> wrote:
> Luis R. Rodriguez <lrodriguez@...> writes:
>
>> =C2=A0void reg_device_remove(struct wiphy *wiphy)
>> =C2=A0{
>> - =C2=A0 =C2=A0 struct wiphy *request_wiphy;
>> + =C2=A0 =C2=A0 struct wiphy *request_wiphy =3D NULL;
> I think the assignment of NULL to request_wiphy is not necessary here=
,

Sparse complains otherwise, or gcc, I forget which.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
