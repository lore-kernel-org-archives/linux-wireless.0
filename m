Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:65500 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2BFV1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 16:27:44 -0500
Received: by qafk1 with SMTP id k1so3889461qaf.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 13:27:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1DC40B07CD6EC041A66726C271A73AE611F67E@IRSMSX102.ger.corp.intel.com>
References: <CAObL_7E2eW9aqz3VLsBU-=4+kMXrfPvfz6wCNUEdDHuJWVaSLA@mail.gmail.com>
	<CAFZTsKk9ojw9_XodisHf-dtHpL1n6xSRmmWDVniZ-Ps4-JLwvA@mail.gmail.com>
	<1328455870.7290.43.camel@wwguy-huron>
	<1DC40B07CD6EC041A66726C271A73AE611F67E@IRSMSX102.ger.corp.intel.com>
Date: Mon, 6 Feb 2012 22:27:43 +0100
Message-ID: <CAFZTsKnjkJSmMdNpNkQWzUggNcN+3Qx0OGVXzuPDsXr8+h1SiA@mail.gmail.com> (sfid-20120206_222748_513328_D72EBBF9)
Subject: Re: [Ilw] Re: 6300agn: queue stuck and driver doesn't recover
From: Alexander Schnaidt <alex.schnaidt@googlemail.com>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	Andrew Lutomirski <luto@mit.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 8:39 AM, Berg, Johannes <johannes.berg@intel.com> wrote:
>> > I tried to bisect it but ended up at:
>> >
>> > commit 3c607d27c818cf4a5d28f2c73b18a88f8fbdfa33
>> > Author: Don Fry <donald.h.fry@intel.com>
>> > Date:   Fri Sep 30 11:40:20 2011 -0700
>> >
>> >     iwlagn: rename iwlagn module iwlwifi and alias to iwlagn.
>
>> I agree that does not make much sense, but we will take a look into it.
>
> I think you probably had something like "options iwlagn 11n_disable=1" or so in /etc/modprobe.d/ somewhere. This caused the problem to happen only with the driver called "iwlwifi", since "iwlagn" would get 11n disabled.
>
> johannes

Thanks for the hint!

You're almost spot on!, somewhere along the bisect I put swcrypto=1 into
modprobe.conf... so much for scientific reproducibility. Sorry for that.

I redid the whole bisect with no options in modprobe.conf which defaults
to swcrypto=0 on >=3.0 if I'm not mistaken.

Heres the bisect log:
git bisect start
# bad: [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
git bisect bad c3b92c8787367a8bb53d57d9789b558f1295cc96
# good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
git bisect good 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
# bad: [138051659902da7e6a09d379fee5dade2a80fcfd]
Merge branch 'staging-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
git bisect bad 138051659902da7e6a09d379fee5dade2a80fcfd
# good: [9d1c02135516866cbbb2f80e20cfb65c63a3ce40]
Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs
git bisect good 9d1c02135516866cbbb2f80e20cfb65c63a3ce40
# bad: [ae4c42e4e4d76d003f8ca551fe1aef93ff9a4b21]
Merge branch 'next/cleanup' of
git://git.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc
git bisect bad ae4c42e4e4d76d003f8ca551fe1aef93ff9a4b21
# good: [ff0c4ad2c3a75ccfe6adca916e50804eb45bb2d9]
Merge branch 'for-upstream' of git://openrisc.net/jonas/linux
git bisect good ff0c4ad2c3a75ccfe6adca916e50804eb45bb2d9
# good: [933b44732caad0c3b65224453c54846c75d97936]
gma500: udlay(20000) is too large
git bisect good 933b44732caad0c3b65224453c54846c75d97936
# bad: [096a705bbc080a4041636d07514560da8d78acbe]
Merge branch 'for-3.1/core' of git://git.kernel.dk/linux-block
git bisect bad 096a705bbc080a4041636d07514560da8d78acbe
# bad: [e1b1c0875daa8ef396593270b5d3ec0b8483c1ea]
iwlagn: rename iwlagn_set_dynamic_key
git bisect bad e1b1c0875daa8ef396593270b5d3ec0b8483c1ea
# good: [b473bc176702cb22529632b5c4315bda27e0d979]
b43: HT-PHY: fix typo in 0x2059 radio init
git bisect good b473bc176702cb22529632b5c4315bda27e0d979
# good: [3db4f989384c90f5f6be14e88c19732bfb0ac331]
libertas: mesh: misc cleanup
git bisect good 3db4f989384c90f5f6be14e88c19732bfb0ac331
# good: [41c50542669cd7aec45ad708f5120ff8fdaa1194]
iwlagn: transport layer receives struct iwl_trans*
git bisect good 41c50542669cd7aec45ad708f5120ff8fdaa1194
# good: [898ed67be047d0762cc7592f67bf1313dff53ca9]
iwlagn: remove un-necessary "_agn"
git bisect good 898ed67be047d0762cc7592f67bf1313dff53ca9
# bad: [c8ac61cf6e53fefb3b439fc58390fb65d2730e63]
iwlagn: implement WoWLAN
git bisect bad c8ac61cf6e53fefb3b439fc58390fb65d2730e63
# bad: [5a3d9882b84edf5fa8e8ca33a5d6df25e2e727a5]
iwlagn: rewrite HW crypto
git bisect bad 5a3d9882b84edf5fa8e8ca33a5d6df25e2e727a5
# good: [0bfe9895d402faf03d5ccd30cc0e6bbad09e5bbc]
iwlagn: remove forgotten debugfs function
git bisect good 0bfe9895d402faf03d5ccd30cc0e6bbad09e5bbc

If my interpretation is right the culprit would be:

commit 5a3d9882b84edf5fa8e8ca33a5d6df25e2e727a5
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Jul 15 13:03:12 2011 -0700

    iwlagn: rewrite HW crypto

    As I just discovered while doing WoWLAN, HW crypto
    is done wrong for GTKs: they should be programmed
    for the AP station ID (in the managed mode case)
    and the HW can actually deal with multiple group
    keys per station as well (which is useful in IBSS
    RSN but that I've chosen not to use this).

    To fix all this, modify the way keys are sent to
    the device and key offsets are allocated. After
    these changes, key offsets are stored into the
    hw_key_idx which we can then track for the key
    lifetime, not relying on our sta_cmd array. WEP
    default keys get special treatment, of course.

    Additionally, since I had the API for it, we can
    now pre-fill TKIP phase 1 keys for RX now that we
    can obtain the P1K from mac80211, a capability I
    had added for WoWLAN initially.

    Finally, some keys simply don't need to be added
    into the device's key cache -- a key that won't
    be used for RX is only needed in the TX header,
    so "pretend" to have accepted any key without
    adding it into the device -- no need to use up
    key space there for it.

    Signed-off-by: Johannes Berg <johannes.berg@intel.com>
    Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

To me it makes sense considering that swcrypto=1 fixes
my problems all the way up till kernel 3.3.0-rc2.

ps.: 11n_disable=1 as suggested by Wey-Yi does not
change the faulty behavior.

Again I apologize for my blunder and thanks for the effort.

alex
