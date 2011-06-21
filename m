Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:37529 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751676Ab1FUVXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 17:23:45 -0400
Date: Tue, 21 Jun 2011 14:23:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC][PATCH v3 7/7] NFC: add Documentation/networking/nfc.txt
Message-Id: <20110621142343.a15b462f.rdunlap@xenotime.net> (sfid-20110621_232349_324208_65FE4672)
In-Reply-To: <1308601481-15815-1-git-send-email-aloisio.almeida@openbossa.org>
References: <1308592212-5755-8-git-send-email-aloisio.almeida@openbossa.org>
	<1308601481-15815-1-git-send-email-aloisio.almeida@openbossa.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 20 Jun 2011 17:24:41 -0300 Aloisio Almeida Jr wrote:

> Signed-off-by: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Signed-off-by: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> ---
>  Documentation/networking/nfc.txt |  128 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 128 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/networking/nfc.txt
> 
> diff --git a/Documentation/networking/nfc.txt b/Documentation/networking/nfc.txt
> new file mode 100644
> index 0000000..cb23b48
> --- /dev/null
> +++ b/Documentation/networking/nfc.txt
> @@ -0,0 +1,128 @@
> +Linux NFC subsystem
> +===================
> +
> +The Near Field Communication (NFC) subsystem is required to standardize the
> +NFC device drivers development and to create an unified userspace interface.
> +
> +This document covers the architecture overview, the device driver interface
> +description and the userspace interface description.
> +
> +Architecture overview
> +---------------------
> +
> +The NFC subsystem is responsible for:
> +      - NFC adapters management;
> +      - Polling for targets;
> +      - Low-level data exchange;
> +
> +The subsystem is divided in some parts. The 'core' is responsible for
> +providing the device driver interface. On the other side, it is also
> +responsible for providing an interface to control operations and low-level
> +data exchange.
> +
> +The control operations are available to userspace via generic netlink.
> +
> +The low-level data exchange interface is provided by the new socket family
> +PF_NFC. The NFC_SOCKPROTO_RAW performs raw communication with NFC targets.
> +
> +
> +             +--------------------------------------+
> +             |              USER SPACE              |
> +             +--------------------------------------+
> +                 ^                       ^
> +                 | low-level             | control
> +                 | data exchange         | operations
> +                 |                       |
> +                 |                       v
> +                 |                  +-----------+
> +                 | AF_NFC           |  netlink  |
> +                 | socket           +-----------+
> +                 | raw                   ^
> +                 |                       |
> +                 v                       v
> +             +---------+            +-----------+
> +             | rawsock | <--------> |   core    |
> +             +---------+            +-----------+
> +                                         ^
> +                                         |
> +                                         v
> +                                    +-----------+
> +                                    |  driver   |
> +                                    +-----------+
> +
> +Device Driver Interface
> +-----------------------
> +
> +When registering on the NFC subsystem, the device driver must inform the set

                                                            must inform the core of the set

> +of supported NFC protocols and the set of ops callbacks. The ops callbacks
> +that must be implemented are the following:
> +
> +* start_poll - setup the device to poll for targets
> +* stop_poll - stop on progress polling operation
> +* activate_target - select and initialize one of the targets found
> +* deactivate_target - deselect and deinitialize the selected target
> +* data_exchange - send data and receive the response (transceive operation)
> +
> +Userspace interface
> +--------------------
> +
> +The userspace interface is divided in control operations and low-level data
> +exchange operation.
> +
> +CONTROL OPERATIONS:
> +
> +Generic netlink was used to implement the interface to the control operations.

                   is used

> +The operations are composed by commands and events, all listed below:
> +
> +* NFC_CMD_GET_DEVICE - get an specific device info or dump the device list

                          get specific device info or

> +* NFC_CMD_START_POLL - setup a specific device to polling for targets
> +* NFC_CMD_STOP_POLL - stop the polling operation in a specific device
> +* NFC_CMD_GET_TARGET - dump the list of targets found by a specific device
> +
> +* NFC_EVENT_DEVICE_ADDED - reports a NFC device addition

                                      an NFC

> +* NFC_EVENT_DEVICE_REMOVED - reports a NFC device removal

                                        an NFC

> +* NFC_EVENT_TARGETS_FOUND - reports START_POLL results when 1 or more targets
> +are found
> +
> +The user must call START_POLL to poll for NFC targets, passing the desired NFC
> +protocols through NFC_ATTR_PROTOCOLS attribute. The device remains in polling
> +state until it finds any target. However, the user can stop the polling
> +operation by calling STOP_POLL command. In this case, it will be checked if
> +the requester of STOP_POLL is the same of START_POLL.
> +
> +If the polling operation finds one or more targets, the event TARGETS_FOUND is
> +sent (including the device id). The user must call GET_TARGET to get the list of
> +all targets found by such device. Each reply message has target attributes with
> +relevant information such as the supported NFC protocols.
> +
> +All polling operations requested through one netlink socket are stopped when
> +it's closed.
> +
> +LOW-LEVEL DATA EXCHANGE:
> +
> +The userspace must use PF_NFC sockets to perform any data communication with
> +targets. All NFC sockets use AF_NFC:
> +
> +struct sockaddr_nfc {
> +       sa_family_t sa_family;
> +       __u32 dev_idx;
> +       __u32 target_idx;
> +       __u32 nfc_protocol;
> +};
> +
> +To establish a connection with one target, the user must create a

                                                            create an

> +NFC_SOCKPROTO_RAW socket and call the 'connect' syscall with the sockaddr_nfc
> +struct correctly filled. All information comes from NFC_EVENT_TARGETS_FOUND
> +netlink event. As a target can support more than one NFC protocol, the user
> +must inform which protocol it wants to use.
> +
> +Internally, 'connect' will result in a activate_target call to the driver.

                                     in an

> +When the socket is closed, the target is deactivated.
> +
> +The data format exchanged through the sockets is NFC protocol dependent. For
> +instance, when communicating with MIFARE tags, the data exchanged are MIFARE
> +commands and their responses.
> +
> +The first received package is the response to the first sent package and so
> +on. In order to allow valid "empty" responses, every data received has a NULL
> +header of 1 byte.
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
