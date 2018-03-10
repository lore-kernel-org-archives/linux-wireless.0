Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:38940 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750985AbeCJRQi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 12:16:38 -0500
Received: by mail-vk0-f67.google.com with SMTP id f6so3972746vkh.6
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2018 09:16:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 10 Mar 2018 09:16:36 -0800
Message-ID: <CAGXu5jJqzahD=iwv8_ipvebi8kQ=UVPiMrHOtQL5iLyviFm6jQ@mail.gmail.com> (sfid-20180310_181656_371497_0985782A)
Subject: Re: [PATCH v3 00/20] firmware: development for v4.17
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bitterblue of Monsea <cantabile.desu@gmail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Martin Fuzzey <mfuzzey@parkeon.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, pali.rohar@gmail.com,
        Takashi Iwai <tiwai@suse.de>, arend.vanspriel@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Nicolas Broeking <nbroeking@me.com>,
        Vikram Mulukutla <markivx@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Abhay_Salunke@dell.com, bjorn.andersson@linaro.org,
        jewalt@lgsinnovations.com, oneukum@suse.com, ast@fb.com,
        andresx7@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 10, 2018 at 6:14 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> Greg,
>
> Here's a respin of what I have queued up for v4.17 for the firmware API. It
> combines the cleanup I've been working on and the addition of the new API call
> request_firmware_cache() for fixing a corner case suspend issue on some type of
> cards with an optimization in place where the firmware is *not* needed on
> reboot.
>
> The cleanup work allows us to test the firmware API with one kernel
> configuration. I've addressed Kees' feedback on this respin and
> combined the code into drivers/base/firmware_class/.
>
> I've made one new test_firmware change in consideration for one firmware
> change, the patch "firmware: ensure the firmware cache is not used on
> incompatible calls" requires us to modify our tests scripts to use
> the APIs sanely as well.
>
> I've put up these changes on my git tree, refer to the branch
> "20180307-firmware-dev-for-v4.17" based on linux-next [0] and
> the same name based on Linus' tree [1].
>
> Questions, feedback, and specially rants are always welcomed.

This all looks good to me! Thanks for respinning. :)

-Kees

>
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20180307-firmware-dev-for-v4.17
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20180307-firmware-dev-for-v4.17
>
> Luis R. Rodriguez (20):
>   test_firmware: add simple firmware firmware test library
>   test_firmware: enable custom fallback testing on limited kernel
>     configs
>   test_firmware: replace syfs fallback check with kconfig_has helper
>   firmware: enable to split firmware_class into separate target files
>   firmware: simplify CONFIG_FW_LOADER_USER_HELPER_FALLBACK further
>   firmware: use helpers for setting up a temporary cache timeout
>   firmware: move loading timeout under struct firmware_fallback_config
>   firmware: split firmware fallback functionality into its own file
>   firmware: move firmware loader into its own directory
>   firmware: enable run time change of forcing fallback loader
>   firmware: enable to force disable the fallback mechanism at run time
>   test_firmware: expand on library with shared helpers
>   test_firmware: test three firmware kernel configs using a proc knob
>   rename: _request_firmware_load() fw_load_sysfs_fallback()
>   firmware: fix checking for return values for fw_add_devm_name()
>   firmware: add helper to check to see if fw cache is setup
>   test_firmware: modify custom fallback tests to use unique files
>   firmware: ensure the firmware cache is not used on incompatible calls
>   firmware: add request_firmware_cache() to help with cache on reboot
>   mt7601u: use request_firmware_cache() to address cache on reboot
>
>  .../driver-api/firmware/fallback-mechanisms.rst    |   2 +-
>  .../driver-api/firmware/request_firmware.rst       |  14 +
>  MAINTAINERS                                        |   2 +-
>  drivers/base/Makefile                              |   2 +-
>  drivers/base/firmware_loader/Makefile              |   7 +
>  drivers/base/firmware_loader/fallback.c            | 674 +++++++++++++++++
>  drivers/base/firmware_loader/fallback.h            |  67 ++
>  drivers/base/firmware_loader/fallback_table.c      |  55 ++
>  drivers/base/firmware_loader/firmware.h            | 115 +++
>  .../{firmware_class.c => firmware_loader/main.c}   | 833 ++-------------------
>  drivers/net/wireless/mediatek/mt7601u/mcu.c        |   2 +-
>  include/linux/firmware.h                           |   3 +
>  kernel/sysctl.c                                    |  11 +
>  tools/testing/selftests/firmware/Makefile          |   2 +-
>  tools/testing/selftests/firmware/config            |   4 +
>  tools/testing/selftests/firmware/fw_fallback.sh    |  65 +-
>  tools/testing/selftests/firmware/fw_filesystem.sh  |  72 +-
>  tools/testing/selftests/firmware/fw_lib.sh         | 194 +++++
>  tools/testing/selftests/firmware/fw_run_tests.sh   |  70 ++
>  19 files changed, 1332 insertions(+), 862 deletions(-)
>  create mode 100644 drivers/base/firmware_loader/Makefile
>  create mode 100644 drivers/base/firmware_loader/fallback.c
>  create mode 100644 drivers/base/firmware_loader/fallback.h
>  create mode 100644 drivers/base/firmware_loader/fallback_table.c
>  create mode 100644 drivers/base/firmware_loader/firmware.h
>  rename drivers/base/{firmware_class.c => firmware_loader/main.c} (60%)
>  create mode 100755 tools/testing/selftests/firmware/fw_lib.sh
>  create mode 100755 tools/testing/selftests/firmware/fw_run_tests.sh
>
> --
> 2.16.2
>



-- 
Kees Cook
Pixel Security
