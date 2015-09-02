Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35079 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbIBRhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 13:37:31 -0400
Subject: Re: Linux Firmware Signing
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Kees Cook <keescook@chromium.org>
References: <1440462367.2737.4.camel@linux.vnet.ibm.com>
 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
 <1440464705.2737.36.camel@linux.vnet.ibm.com>
 <14540.1440599584@warthog.procyon.org.uk>
 <31228.1440671938@warthog.procyon.org.uk>
 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
 <20150827212907.GF8051@wotan.suse.de>
 <1440719673.2118.84.camel@linux.vnet.ibm.com>
 <20150829021659.GN8051@wotan.suse.de>
 <1441030735.2647.70.camel@linux.vnet.ibm.com>
 <20150901234305.GU8051@wotan.suse.de>
 <CAGXu5j+_yHc1wbubzw4h=QFM=uyn1pCraGYCWS6LvgtS3-A+Qw@mail.gmail.com>
 <1441165462.17898.94.camel@linux.vnet.ibm.com>
 <CAGXu5jJ7XGzYD=HX13SavVXSqZ_DvOKU2udym91tM4RFknapZw@mail.gmail.com>
 <1441212343.17898.142.camel@linux.vnet.ibm.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@parisplace.org>,
	SE Linux <selinux@tycho.nsa.gov>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>, Joey Lee <jlee@suse.de>,
	=?UTF-8?Q?Vojt=c4=9bch_Pavl=c3=adk?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Jay Schulist <jschlst@samba.org>,
	Daniel Borkmann <dborkman@redhat.com>,
	Alexei Starovoitov <ast@plumgrid.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55E73399.2040502@gmail.com> (sfid-20150902_193738_871962_6F8E24ED)
Date: Wed, 2 Sep 2015 13:36:25 -0400
MIME-Version: 1.0
In-Reply-To: <1441212343.17898.142.camel@linux.vnet.ibm.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060908000709050105060001"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060908000709050105060001
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-02 12:45, Mimi Zohar wrote:
> On Wed, 2015-09-02 at 08:28 -0700, Kees Cook wrote:
>> On Tue, Sep 1, 2015 at 8:44 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> =
wrote:
>>> On Tue, 2015-09-01 at 20:08 -0700, Kees Cook wrote:
>>>> On Tue, Sep 1, 2015 at 4:43 PM, Luis R. Rodriguez <mcgrof@suse.com> =
wrote:
>>>>> On Mon, Aug 31, 2015 at 10:18:55AM -0400, Mimi Zohar wrote:
>>>>>>>> eBPF/seccomp
>>>>>
>>>>> OK I knew nothing about this but I just looked into it, here are my=
 notes:
>>>>>
>>>>>    * old BPF - how far do we want to go? This goes so far as to par=
sing
>>>>>      user passed void __user *arg data through ioctls which typical=
ly
>>>>>      gets copy_from_user()'d and eventually gets BPF_PROG_RUN().
>>>>>
>>>>>    * eBPF:
>>>>>                               seccomp() & prctl_set_seccomp()
>>>>>                                          |
>>>>>                                          V
>>>>>                               do_seccomp()
>>>>>                                          |
>>>>>                                          V
>>>>>                               seccomp_set_mode_filter()
>>>>>                                          |
>>>>>                                          V
>>>>>                               seccomp_prepare_user_filter()
>>>>>                                          |
>>>>>                                          V
>>>>>          bpf_prog_create_from_user() (seccomp) \
>>>>>          bpf_prog_create()                      > bpf_prepare_filte=
r()
>>>>>          sk_attach_filter()                    /
>>>>>
>>>>>      All approaches come from user passed data, nothing fd based.
>>>>>
>>>>>      For both old BPF and eBPF then:
>>>>>
>>>>>      If we wanted to be paranoid I suppose the Machine Owner Key (M=
OK)
>>>>>      Paul had mentioned up could be used to vet for passed filters,=
 or
>>>>>      a new interface to enable fd based filters. This really would =
limit
>>>>>      the dynamic nature of these features though.
>>>>>
>>>>>      eBPF / secccomp would not be the only place in the kernel that=
 would have
>>>>>      issues with user passed data, we have tons of places the same =
applies so
>>>>>      implicating the old BPF / eBPF / seccomp approaches can easily=
 implicate
>>>>>      many other areas of the kernel, that's pretty huge but from th=
e looks of
>>>>>      it below you seem to enable that to be a possibility for us to=
 consider.
>>>>
>>>> At the time (LSS 2014?) I argued that seccomp policies come from
>>>> binaries, which are already being measured. And that policies only
>>>> further restrict a process, so there seems to be to be little risk i=
n
>>>> continuing to leave them unmeasured.
>>>
>>> What do you mean by "measured"?  Who is doing the measurement?  Could=

>>> someone detect a change in measurement?
>>
>> I meant from the perspective of IMA. The binary would have already
>> been evaluated when it executed, and it's what's installing the
>> seccomp filter. And since seccomp filters can only reduce privilege,
>> it seems like they're not worth getting processed by IMA. But I might
>> not understand the requirements! :)
>
> So because we trust the binary, we can trust the resulting output that
> is loaded into the kernel.  That assumes the trusted binary appraises
> it's input, right?   We're relying on seccomp filters to reduce
> privileges properly.   This isn't any different than trusting any other=

> policies consumed by the kernel.
>
Except many binaries that use seccomp (at least most of the ones that=20
I've seen) don't change the filter based on input, but have it=20
hard-coded into the binary and only offer to turn it on or off based on=20
user input.



--------------ms060908000709050105060001
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTAyMTczNjI1WjBPBgkq
hkiG9w0BCQQxQgRAyWWUUJsSJ2ydYb6CQRRF0Cpuwq4nIzoWUF+I1h7jeTLseoeqfCmLq1tQ
0iRSmc66EoDy+FoXRKpsnXUXypm9TTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgCayxWbAs/+vqllDBD4WESc4t42UErpH44zPAIpVFViNtNqHXZ9
3QOycOHABdBH0QnLTCgVSbCpvxnKuunDUkOUZGINtfivCRAOqaFgm6FmkNYnvJNMlNmIIsST
L1Ouk9d7ziS5kvvu1I0CJ0Fp90E5Z6Vfhliwx5veI/ezLOlLjvA+jhuN3xPogO6qvdoBJOO4
yBA0+FhyjLSvEoYBW6fXJcfCSN2YW9GtI+dFaVAvKIDoWDwLKpHQD2E1Spk7k5E8e5eXlrxK
ylHaD+tPcAO7wiYPIynXaGZA9c7AOWhamswRejHZdSyTLJNNB7Rjoo6m+BqoUP5i1W5qBNHA
e5IlvmgprhLGZOkGBuRA1zPkkG4OupWGK2vHNVwjltJA41sThbRR53Vz7hE5pBFS4P6SHZ9G
UsMwxtTVSHODHjacNMnOE74MjDQRFVdrSiNZr4/6ddF5UJndfLjvmHk5kfAL5UpMHU7aUuwS
NCVGQFXA7LrwbFxa5xFsoc02OLi5HPmpeJolns8QBGWD47yaUKfTO9lYKZxXGbXDO0ioFWlM
Kmz6wfYNHjo/KY/bVF9xf8RPP1uxE/f+ix7zPdFmWPcXdOwtnAZbT+Jq6BTTmDsuSld19qmG
vJyfJQeVxhsfr3U7N4amRwCRsMulwVtZvUVs618AuOq386pibvu6o4PM5gAAAAAAAA==
--------------ms060908000709050105060001--
