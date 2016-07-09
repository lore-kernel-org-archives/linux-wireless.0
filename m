Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:12976 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbcGISXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 14:23:53 -0400
Date: Sun, 10 Jul 2016 02:23:05 +0800
From: kbuild test robot <lkp@intel.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: kbuild-all@01.org, zajec5@gmail.com, viresh.kumar@linaro.org,
	akpm@linux-foundation.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: Re: [v1] ErrHandling:Make IS_ERR_VALUE_U32 as generic API to avoid
 IS_ERR_VALUE abuses.
Message-ID: <201607100229.1QmGOEYE%fengguang.wu@intel.com> (sfid-20160709_202432_530415_FC043948)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
In-Reply-To: <1468079460-10153-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

[auto build test WARNING on v4.7-rc6]
[also build test WARNING on next-20160708]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Arvind-Yadav/ErrHandling-Make-IS_ERR_VALUE_U32-as-generic-API-to-avoid-IS_ERR_VALUE-abuses/20160709-235356
config: x86_64-randconfig-x007-201628 (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mod_devicetable.h:11,
                    from include/linux/pci.h:20,
                    from include/linux/bcma/bcma.h:4,
                    from drivers/bcma/bcma_private.h:8,
                    from drivers/bcma/scan.c:9:
   drivers/bcma/scan.c: In function 'bcma_get_next_core':
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/compiler.h:127:14: note: in expansion of macro 'likely_notrace'
       ______r = likely_notrace(x);   \
                 ^~~~~~~~~~~~~~
   include/linux/compiler.h:141:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/compiler.h:127:14: note: in expansion of macro 'likely_notrace'
       ______r = likely_notrace(x);   \
                 ^~~~~~~~~~~~~~
   include/linux/compiler.h:141:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:151:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:151:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:151:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:151:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:151:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/compiler.h:127:14: note: in expansion of macro 'likely_notrace'
       ______r = likely_notrace(x);   \
                 ^~~~~~~~~~~~~~
   include/linux/compiler.h:141:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:151:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/compiler.h:127:14: note: in expansion of macro 'likely_notrace'
       ______r = likely_notrace(x);   \
                 ^~~~~~~~~~~~~~
   include/linux/compiler.h:141:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:162:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:162:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:162:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:162:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:162:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/compiler.h:127:14: note: in expansion of macro 'likely_notrace'
       ______r = likely_notrace(x);   \
                 ^~~~~~~~~~~~~~
   include/linux/compiler.h:141:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:162:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
>> drivers/bcma/scan.c:361:2: note: in expansion of macro 'if'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
     ^~
   include/linux/compiler.h:127:14: note: in expansion of macro 'likely_notrace'
       ______r = likely_notrace(x);   \
                 ^~~~~~~~~~~~~~
   include/linux/compiler.h:141:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:361:18: note: in expansion of macro 'IS_ERR_VALUE_U32'
     if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                     ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
   drivers/bcma/scan.c:365:3: note: in expansion of macro 'if'
      if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
      ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:365:19: note: in expansion of macro 'IS_ERR_VALUE_U32'
      if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                      ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
   drivers/bcma/scan.c:365:3: note: in expansion of macro 'if'
      if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
      ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:365:19: note: in expansion of macro 'IS_ERR_VALUE_U32'
      if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                      ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
   drivers/bcma/scan.c:365:3: note: in expansion of macro 'if'
      if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
      ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:365:19: note: in expansion of macro 'IS_ERR_VALUE_U32'
      if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                      ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
   drivers/bcma/scan.c:365:3: note: in expansion of macro 'if'
      if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
      ^~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:365:19: note: in expansion of macro 'IS_ERR_VALUE_U32'
      if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                      ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:52: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                                       ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
   drivers/bcma/scan.c:365:3: note: in expansion of macro 'if'
      if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
      ^~
   include/linux/compiler.h:127:14: note: in expansion of macro 'likely_notrace'
       ______r = likely_notrace(x);   \
                 ^~~~~~~~~~~~~~
   include/linux/compiler.h:141:58: note: in expansion of macro '__branch_check__'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                                             ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:29: note: in expansion of macro 'unlikely'
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                ^~~~~~~~
   drivers/bcma/scan.c:365:19: note: in expansion of macro 'IS_ERR_VALUE_U32'
      if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
                      ^~~~~~~~~~~~~~~~
   include/linux/err.h:23:38: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    #define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(void *)(x) >= (unsigned int)-MAX_ERRNO)
                                         ^
   include/linux/compiler.h:151:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \

vim +/if +361 drivers/bcma/scan.c

517f43e5 Hauke Mehrtens 2011-07-23  345  	    )) {
517f43e5 Hauke Mehrtens 2011-07-23  346  		bcma_erom_skip_component(bus, eromptr);
517f43e5 Hauke Mehrtens 2011-07-23  347  		return -ENODEV;
517f43e5 Hauke Mehrtens 2011-07-23  348  	}
517f43e5 Hauke Mehrtens 2011-07-23  349  
8369ae33 Rafał Miłecki  2011-05-09  350  	/* get & parse master ports */
8369ae33 Rafał Miłecki  2011-05-09  351  	for (i = 0; i < ports[0]; i++) {
4e0d8cc1 Dan Carpenter  2011-08-23  352  		s32 mst_port_d = bcma_erom_get_mst_port(bus, eromptr);
982eee67 Hauke Mehrtens 2011-07-23  353  		if (mst_port_d < 0)
982eee67 Hauke Mehrtens 2011-07-23  354  			return -EILSEQ;
8369ae33 Rafał Miłecki  2011-05-09  355  	}
8369ae33 Rafał Miłecki  2011-05-09  356  
e167d9fb Hauke Mehrtens 2012-03-15  357  	/* First Slave Address Descriptor should be port 0:
e167d9fb Hauke Mehrtens 2012-03-15  358  	 * the main register space for the core
e167d9fb Hauke Mehrtens 2012-03-15  359  	 */
e167d9fb Hauke Mehrtens 2012-03-15  360  	tmp = bcma_erom_get_addr_desc(bus, eromptr, SCAN_ADDR_TYPE_SLAVE, 0);
aaa2ced1 Hauke Mehrtens 2013-09-07 @361  	if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
e167d9fb Hauke Mehrtens 2012-03-15  362  		/* Try again to see if it is a bridge */
e167d9fb Hauke Mehrtens 2012-03-15  363  		tmp = bcma_erom_get_addr_desc(bus, eromptr,
e167d9fb Hauke Mehrtens 2012-03-15  364  					      SCAN_ADDR_TYPE_BRIDGE, 0);
aaa2ced1 Hauke Mehrtens 2013-09-07  365  		if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
e167d9fb Hauke Mehrtens 2012-03-15  366  			return -EILSEQ;
e167d9fb Hauke Mehrtens 2012-03-15  367  		} else {
3d9d8af3 Rafał Miłecki  2012-07-05  368  			bcma_info(bus, "Bridge found\n");
e167d9fb Hauke Mehrtens 2012-03-15  369  			return -ENXIO;

:::::: The code at line 361 was first introduced by commit
:::::: aaa2ced15ad8dca8048666c9f70736424d696a6b bcma: fix error code handling on 64 Bit systems

:::::: TO: Hauke Mehrtens <hauke@hauke-m.de>
:::::: CC: John W. Linville <linville@tuxdriver.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--YZ5djTAD1cGYuMQK
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
/D9yzokjhlgBAA==

--YZ5djTAD1cGYuMQK--
