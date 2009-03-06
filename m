Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:25392 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZCFF2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 00:28:06 -0500
Received: by rv-out-0506.google.com with SMTP id g37so322572rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 21:28:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1236316669-10093-1-git-send-email-lrodriguez@atheros.com>
References: <1236316669-10093-1-git-send-email-lrodriguez@atheros.com>
Date: Fri, 6 Mar 2009 16:28:03 +1100
Message-ID: <646765f40903052128m345d458fn256bfa5c14974096@mail.gmail.com> (sfid-20090306_062820_261082_05A03DD9)
Subject: Re: [PATCH] wireless-regdb: sanity checks on freq range
From: Julian Calaby <julian.calaby@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 6, 2009 at 16:17, Luis R. Rodriguez <lrodriguez@atheros.com=
> wrote:
> diff --git a/dbparse.py b/dbparse.py
> index 55615bd..dd64927 100755
> --- a/dbparse.py
> +++ b/dbparse.py
> @@ -136,6 +136,19 @@ class DBParser(object):
> =A0 =A0 =A0 =A0 =A0 =A0 start, end =3D freqs.split('-')
> =A0 =A0 =A0 =A0 =A0 =A0 start =3D float(start)
> =A0 =A0 =A0 =A0 =A0 =A0 end =3D float(end)
> + =A0 =A0 =A0 =A0 =A0 =A0# The kernel will reject these, so might as =
well reject this
> + =A0 =A0 =A0 =A0 =A0 =A0# upon building it.
> + =A0 =A0 =A0 =A0 =A0 =A0if start <=3D 0:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 self._syntax_error("Invalid start freq =
(%d)" % start)
> + =A0 =A0 =A0 =A0 =A0 =A0if end <=3D 0:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 self._syntax_error("Invalid end freq (%=
d)" % end)
> + =A0 =A0 =A0 =A0 =A0 =A0if start > end:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 self._syntax_error("Inverted freq range=
 it seems (%d - %d)" % (start, end))

"Inverted freq range" only?

> + =A0 =A0 =A0 =A0 =A0 =A0if end - start <=3D 0:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 self._syntax_error("Invalid bandwidth (=
%d)" % bw)

This is equivalent to "end <=3D start" which is equivalent to "start >=3D
end" which is mostly covered by the previous test.

Wouldn't it be clearer to have something like: (I don't have
Python-fu, so take this with salt)
if start =3D=3D end:
    self._syntax_error("Start and end freqs are equivalent")

Thanks,

--=20

Julian Calaby

Email: julian.calaby@gmail.com
=2EPlan: http://sites.google.com/site/juliancalaby/
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
