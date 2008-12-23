Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:52472 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYLWPDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 10:03:34 -0500
Received: by yw-out-2324.google.com with SMTP id 9so867606ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 07:03:32 -0800 (PST)
Message-ID: <43e72e890812230703u31ca4ef9jbef83918156da27@mail.gmail.com> (sfid-20081223_160336_747054_14A25054)
Date: Tue, 23 Dec 2008 07:03:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W Linville" <linville@tuxdriver.com>
In-Reply-To: <20081223095811.lmog5le728wccowc-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
	 <43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com>
	 <20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net>
	 <43e72e890812222157s5d410d39ye9ac0840eef5331a@mail.gmail.com>
	 <20081223012037.otw1xe4tc084coc8-cebfxv@webmail.spamcop.net>
	 <20081223062219.GT10807@tesla>
	 <20081223095811.lmog5le728wccowc-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 23, 2008 at 6:58 AM, Pavel Roskin <proski@gnu.org> wrote:
> Quoting "Luis R. Rodriguez" <lrodriguez@atheros.com>:
>
>> rm -rf on your wireless-regdb git tree and then git checkout -f.  Then cp
>> that regulatory.bin
>> to the REG_BIN location and try to build that CRDA. Then try that CRDA.
>
> I remember I tried "make" in wireless-regdb without having M2Crypto
> installed.  Then I installed M2Crypto and ran "make clean" followed by
> "make".  "make clean" removed the original regulatory.bin.
>
> The "clean" target doesn't normally remove files under version control.  It
> only removes files that everybody can generate.  For files that are harder
> to create, there is "make distclean" and "make maintainer-clean".

Good catch. I think it would be a lot simpler if we just referred
people to the latest dated regulatory.bin:

http://wireless.kernel.org/download/wireless-regdb/

Maybe have a symlink and have CRDA wget it or something? Thoughts?

  Luis
