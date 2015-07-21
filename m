Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36715 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239AbbGUXOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 19:14:23 -0400
MIME-Version: 1.0
In-Reply-To: <20150714192015.GO7021@wotan.suse.de>
References: <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
 <1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com>
 <CAGXu5jJnPqgpvXd05-dtSbYeSVndcpH1_XMMczPWn5Gq-DUtcw@mail.gmail.com> <20150714192015.GO7021@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 21 Jul 2015 16:14:02 -0700
Message-ID: <CAB=NE6WpVnSD98CQ86ccnziwCuP5cfMDqY++1GWc7Ypv0hkH6A@mail.gmail.com> (sfid-20150722_011441_548312_F8B47EA4)
Subject: Re: [RFC v3 2/2] firmware: add firmware signature checking support
To: Kees Cook <keescook@chromium.org>,
	David Howells <dhowells@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Ming Lei <ming.lei@canonical.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Paul Bolle <pebolle@tiscali.nl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>, jlee@suse.com,
	Takashi Iwai <tiwai@suse.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <David.Woodhouse@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 14, 2015 at 12:20 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> > +       strcpy(signed_name, buf->fw_id);
>> > +       strncat(signed_name, sign_ext, strlen(sign_ext));
>>
>> fw_id is potentially unbounded, so using strncat hear poses an
>> overflow risk. Maybe better to use strlcpy?
>>
>
> Thanks for the feedback, indeed.

Ok I've made this change based on David's tree.

 Luis
